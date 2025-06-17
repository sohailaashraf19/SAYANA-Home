import React, { useState, useEffect, useRef, useCallback } from 'react';
import { IoSend } from 'react-icons/io5';
import { ArrowPathIcon, SpeakerWaveIcon, SpeakerXMarkIcon } from '@heroicons/react/24/outline';
import { CameraIcon, MicrophoneIcon, XMarkIcon } from '@heroicons/react/24/solid';
import imageCompression from 'browser-image-compression';

// Helper function to clean text for speech (removes emojis and markdown)
const cleanTextForSpeech = (text) => {
  if (typeof text !== 'string') return "";
  const emojiRegex = /([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g;
  let cleanedText = text.replace(/(\*\*|##|\*|#|\[|\]|\(|\))/g, ' ');
  cleanedText = cleanedText.replace(emojiRegex, '');
  cleanedText = cleanedText.replace(/\s+/g, ' ').trim();
  return cleanedText;
};

// Sound wave icon component
const SoundWaveIcon = () => (
  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M2 12h4M18 12h4M8 6v12M16 6v12" />
  </svg>
);

// Settings-like icon for voice selection
const VoiceSettingsIcon = () => (
  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M4 12h16M12 4v16" />
  </svg>
);

const ChatBot = () => {
  const [message, setMessage] = useState("");
  const [selectedImage, setSelectedImage] = useState(null);
  const [isResponseScreen, setIsResponseScreen] = useState(false);
  const [messages, setMessages] = useState([]);
  const [voices, setVoices] = useState([]);
  const [selectedVoice, setSelectedVoice] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isListening, setIsListening] = useState(false);
  const [isMuted, setIsMuted] = useState(false);
  const [isCallScreen, setIsCallScreen] = useState(false);
  const [voiceAnimation, setVoiceAnimation] = useState(false);
  const recognitionRef = useRef(null);

  useEffect(() => {
    const loadVoices = () => {
      const allVoices = window.speechSynthesis.getVoices();
      const arabicVoices = allVoices.filter(v => v.lang.startsWith("ar"));
      const otherVoices = allVoices.filter(v => !v.lang.startsWith("ar"));
      const availableVoices = [...arabicVoices, ...otherVoices];
      setVoices(availableVoices);
      if (availableVoices.length > 0) {
        const defaultArabicVoice = arabicVoices.find(v => v.default) || arabicVoices[0];
        if (defaultArabicVoice) setSelectedVoice(defaultArabicVoice);
        else setSelectedVoice(availableVoices.find(v => v.default) || availableVoices[0]);
      }
    };
    if (window.speechSynthesis.getVoices().length === 0) {
      window.speechSynthesis.onvoiceschanged = loadVoices;
    } else {
      loadVoices();
    }
    const voiceInterval = setInterval(() => {
      if (window.speechSynthesis.getVoices().length > 0) {
        loadVoices();
        clearInterval(voiceInterval);
      }
    }, 100);
    return () => clearInterval(voiceInterval);
  }, []);

  useEffect(() => {
    const SpeechRecognitionAPI = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (SpeechRecognitionAPI) {
      const recognition = new SpeechRecognitionAPI();
      recognition.continuous = false;
      recognition.interimResults = false;
      if (selectedVoice && selectedVoice.lang.startsWith('ar')) {
        recognition.lang = selectedVoice.lang;
      } else {
        const arabicSystemVoice = voices.find(v => v.lang.startsWith('ar'));
        recognition.lang = arabicSystemVoice ? arabicSystemVoice.lang : navigator.language || 'en-US';
      }
      
      recognition.onstart = () => {
        setIsListening(true);
        setVoiceAnimation(true);
      };
      recognition.onresult = (event) => {
        const transcript = event.results[0][0].transcript;
        setMessage(transcript);
        if (transcript.trim() || selectedImage) {
          generateResponse(transcript.trim());
        } else {
          setIsListening(false);
          setVoiceAnimation(false);
        }
      };
      recognition.onerror = (event) => {
        let errorMessage = `خطأ في التعرف على الصوت: ${event.error}.`;
        if (event.error === 'not-allowed' || event.error === 'service-not-allowed') errorMessage += " من فضلك، تأكد من السماح باستخدام الميكروفون.";
        else if (event.error === 'no-speech') errorMessage += " لم يتم اكتشاف صوت.";
        const errorDisplay = document.getElementById('error-message-display');
        if (errorDisplay) {
          errorDisplay.textContent = errorMessage;
          errorDisplay.style.display = 'block';
          setTimeout(() => { errorDisplay.style.display = 'none'; }, 5000);
        } else { alert(errorMessage); }
        setIsListening(false);
        setVoiceAnimation(false);
      };
      recognition.onend = () => {
        setIsListening(false);
        setVoiceAnimation(false);
      };
      recognitionRef.current = recognition;
    }
    return () => { if (recognitionRef.current) recognitionRef.current.abort(); };
  }, [selectedVoice, voices, selectedImage]);

  const handleInputChange = (e) => {
    if (e.target.value.length <= 500) setMessage(e.target.value);
  };

  const handleImageUpload = async (e) => {
    const file = e.target.files[0];
    if (file) {
      try {
        const options = { maxSizeMB: 0.5, maxWidthOrHeight: 800, useWebWorker: true };
        const compressedFile = await imageCompression(file, options);
        const reader = new FileReader();
        reader.onloadend = () => setSelectedImage(reader.result);
        reader.readAsDataURL(compressedFile);
      } catch (error) {
        console.error("❌ خطأ في ضغط الصورة:", error);
        alert("فشل في معالجة الصورة. من فضلك، جرب صورة أصغر أو صورة مختلفة.");
      }
    }
  };

  const removeImagePreview = () => setSelectedImage(null);

  const handleToggleMute = () => {
    const newMutedState = !isMuted;
    setIsMuted(newMutedState);
    if (newMutedState && window.speechSynthesis && window.speechSynthesis.speaking) {
      window.speechSynthesis.cancel();
    }
  };

  const speakText = useCallback((text) => {
    if (isMuted || !text || typeof text !== 'string' || text.trim() === "") return;
    if (!window.speechSynthesis) return;
    window.speechSynthesis.cancel();
    const cleanedText = cleanTextForSpeech(text);
    const msg = new SpeechSynthesisUtterance(cleanedText);
    if (selectedVoice) {
      msg.voice = selectedVoice;
      msg.lang = selectedVoice.lang;
    } else if (voices.length > 0) {
      const defaultVoice = voices.find(v => v.default) || voices[0];
      msg.voice = defaultVoice;
      msg.lang = defaultVoice.lang;
    }
    msg.rate = 1;
    msg.pitch = 1;
    msg.volume = 1;
    msg.onstart = () => setVoiceAnimation(true);
    msg.onend = () => setVoiceAnimation(false);
    window.speechSynthesis.speak(msg);
  }, [selectedVoice, voices, isMuted]);

  const generateResponse = useCallback(async (msgContent) => {
    if (isLoading) return;
    setIsLoading(true);
    const errorDisplay = document.getElementById('error-message-display');
    if (errorDisplay) errorDisplay.style.display = 'none';

    const openRouterApiKey = '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';
    const modelToUse = 'deepseek/deepseek-chat';

    try {
      let combinedMessageText = msgContent ? msgContent.trim() : "";
      if (selectedImage) {
        const imageNotification = " [المستخدم قام برفع صورة.]";
        if (combinedMessageText) {
          combinedMessageText += imageNotification;
        } else {
          combinedMessageText = imageNotification.trim();
        }
      }

      if (!combinedMessageText && !selectedImage) {
        const errorMsg = "من فضلك، اكتب رسالة، تحدث، أو قم برفع صورة.";
        if (errorDisplay) {
          errorDisplay.textContent = errorMsg;
          errorDisplay.style.display = 'block';
          setTimeout(() => { errorDisplay.style.display = 'none'; }, 3000);
        } else { alert(errorMsg); }
        setIsLoading(false);
        return;
      }
      
      if (!combinedMessageText && selectedImage) {
        combinedMessageText = "[المستخدم قام برفع صورة.]";
      }
      if (!combinedMessageText) {
        setIsLoading(false);
        return;
      }

      const body = JSON.stringify({
        model: modelToUse,
        messages: [{ role: 'user', content: combinedMessageText }],
        max_tokens: 2048,
        temperature: 0.7,
        stream: false,
      });

      const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${openRouterApiKey}`,
          'Content-Type': 'application/json',
        },
        body: body,
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({error: {message: response.statusText}}));
        let detailedErrorMessage = `خطأ في الـ API: ${response.status} ${response.statusText}`;
        if (errorData.error && errorData.error.message) {
          detailedErrorMessage = `خطأ: ${errorData.error.message} (الحالة: ${response.status})`;
        }
        if (response.status === 401) detailedErrorMessage = "خطأ OpenRouter: غير مصرح - مفتاح API غير صالح.";
        else if (response.status === 403) detailedErrorMessage = "خطأ OpenRouter: ممنوع - تحقق من صلاحيات مفتاح API أو الفوترة.";
        else if (response.status === 429) detailedErrorMessage = "خطأ OpenRouter: تم تجاوز الحصة أو الحد الأقصى. تحقق من خطتك أو انتظر.";
        throw new Error(detailedErrorMessage);
      }

      const data = await response.json();

      if (!data.choices || data.choices.length === 0 || !data.choices[0].message || !data.choices[0].message.content) {
        throw new Error("تنسيق الرد غير صالح من OpenRouter API أو لا يوجد محتوى.");
      }

      const botReplyOriginal = data.choices[0].message.content.trim();
      if (!botReplyOriginal) throw new Error("تم استلام رد فارغ من المساعد.");

      const botReplyCleaned = cleanTextForSpeech(botReplyOriginal);

      const userMessageForDisplay = msgContent || (selectedImage ? "تم رفع الصورة" : "رسالة فارغة");
      
      setMessages(prevMessages => [
        ...prevMessages,
        { type: "userMsg", text: userMessageForDisplay, image: selectedImage },
        { type: "responseMsg", text: botReplyOriginal, speechText: botReplyCleaned }
      ]);
      setIsResponseScreen(true);
      setMessage("");
      setSelectedImage(null);
      speakText(botReplyCleaned);

    } catch (error) {
      console.error("❌ خطأ في generateResponse (OpenRouter):", error);
      const errorMessageToDisplay = "حدث خطأ: " + error.message;
      if (errorDisplay) {
        errorDisplay.textContent = errorMessageToDisplay;
        errorDisplay.style.display = 'block';
        setTimeout(() => { errorDisplay.style.display = 'none'; }, 5000);
      } else { alert(errorMessageToDisplay); }
      
      const userMessageTextOnError = msgContent || (selectedImage ? "تم رفع الصورة" : "محاولة تنفيذ إجراء");
      setMessages(prevMessages => [
        ...prevMessages,
        { type: "userMsg", text: userMessageTextOnError, image: selectedImage },
        { type: "responseMsg", text: "عذرًا، حدث خطأ. من فضلك حاول مرة أخرى.", speechText: "عذرًا، حدث خطأ. من فضلك حاول مرة أخرى." }
      ]);
      setIsResponseScreen(true);
    } finally {
      setIsLoading(false);
    }
  }, [isLoading, selectedImage, speakText]);

  const hitRequest = () => {
    if (message.trim() || selectedImage) {
      generateResponse(message.trim());
    } else {
      const errorMsg = "من فضلك، اكتب رسالة، تحدث، أو قم برفع صورة.";
      const errorDisplay = document.getElementById('error-message-display');
      if (errorDisplay) {
        errorDisplay.textContent = errorMsg;
        errorDisplay.style.display = 'block';
        setTimeout(() => { errorDisplay.style.display = 'none'; }, 3000);
      } else { alert(errorMsg); }
    }
  };

  const handleToggleListening = () => {
    if (!recognitionRef.current) {
      const errorMsg = "التعرف على الصوت غير متاح أو لم يتم تهيئته.";
      const errorDisplay = document.getElementById('error-message-display');
      if (errorDisplay) {
        errorDisplay.textContent = errorMsg;
        errorDisplay.style.display = 'block';
        setTimeout(() => { errorDisplay.style.display = 'none'; }, 3000);
      } else { alert(errorMsg); }
      return;
    }
    if (isListening) {
      recognitionRef.current.stop();
    } else {
      setMessage("");
      try {
        if (selectedVoice && selectedVoice.lang.startsWith('ar')) {
          recognitionRef.current.lang = selectedVoice.lang;
        } else {
          const arabicSystemVoice = voices.find(v => v.lang.startsWith('ar'));
          recognitionRef.current.lang = arabicSystemVoice ? arabicSystemVoice.lang : navigator.language || 'en-US';
        }
        recognitionRef.current.start();
      } catch (error) {
        setIsListening(false);
        setVoiceAnimation(false);
        const errorMsg = "تعذر بدء التعرف على الصوت. قد يكون نشطًا بالفعل أو حدثت مشكلة.";
        const errorDisplay = document.getElementById('error-message-display');
        if (errorDisplay) {
          errorDisplay.textContent = errorMsg;
          errorDisplay.style.display = 'block';
          setTimeout(() => { errorDisplay.style.display = 'none'; }, 3000);
        } else { alert(errorMsg); }
      }
    }
  };

  const newChat = () => {
    setIsResponseScreen(false);
    setMessages([]);
    setMessage("");
    setSelectedImage(null);
    setIsLoading(false);
    setIsListening(false);
    setIsCallScreen(false);
    setVoiceAnimation(false);
    if (window.speechSynthesis) window.speechSynthesis.cancel();
    if (recognitionRef.current && isListening) recognitionRef.current.stop();
  };

  const toggleCallScreen = () => {
    setIsCallScreen(!isCallScreen);
    if (isListening) {
      recognitionRef.current?.stop();
    }
    if (window.speechSynthesis.speaking) {
      window.speechSynthesis.cancel();
    }
  };

  return (
    <>
      <style>
        {`
          @keyframes grow {
            0% {
              transform: scale(0.5);
            }
            100% {
              transform: scale(1);
            }
          }
        `}
      </style>
      <div className="w-full h-full min-h-screen bg-[#FBFBFB] text-black flex flex-col font-sans">
        <div id="error-message-display" className="fixed top-4 left-1/2 -translate-x-1/2 bg-red-600 text-white px-4 py-2 rounded-md shadow-lg z-50 hidden transition-opacity duration-300 opacity-90">
          رسالة الخطأ هنا
        </div>

        {isCallScreen ? (
          <div className="flex flex-col items-center justify-center flex-grow bg-white text-black p-4 relative">
            <div className="absolute top-4 right-4 group">
              <button 
                className="p-3 rounded-full bg-gray-100 hover:bg-gray-200"
                onClick={() => document.getElementById('voiceSelect').focus()}
                aria-label="اختر صوت النطق"
              >
                <VoiceSettingsIcon />
              </button>
              <select 
                id="voiceSelect"
                value={selectedVoice ? selectedVoice.name : ""} 
                onChange={(e) => { const voice = voices.find(v => v.name === e.target.value); setSelectedVoice(voice);}} 
                className="absolute opacity-0 w-0 h-0"
                aria-label="اختر صوت النطق"
              >
                {voices.length > 0 ? (
                  voices.map((voice, idx) => (
                    <option key={idx} value={voice.name}>
                      {voice.name} ({voice.lang}) {voice.default && "(افتراضي)"}
                    </option>
                  ))
                ) : (
                  <option disabled>{selectedVoice?.lang.startsWith('ar') ? '...جاري تحميل الأصوات' : 'جاري تحميل الأصوات...'}</option>
                )}
              </select>
              <div className="absolute top-full mt-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
                اختر الصوت
              </div>
            </div>
            <div className="flex flex-col items-center justify-center flex-grow">
              <div className={`w-32 h-32 rounded-full bg-[#003664]/80 flex items-center justify-center transition-transform duration-1000 ease-out
                ${isCallScreen ? 'animate-grow' : ''} 
                ${voiceAnimation ? 'scale-125' : ''}`}>
                <div className={`w-24 h-24 rounded-full bg-[#002244]/80 
                  ${voiceAnimation ? 'animate-[pulse_1s_ease-in-out_infinite] scale-110' : ''}`}></div>
              </div>
            </div>
            <div className="flex flex-col items-center mt-auto mb-4">
              <p className="text-sm text-black mb-2">{isListening ? "جاري الاستماع..." : "Start a new chat to use advanced voice"}</p>
              <div className="flex gap-8">
                <button 
                  onClick={handleToggleListening} 
                  className={`p-4 rounded-full ${isListening ? 'bg-red-600 animate-pulse' : 'bg-gray-100'} hover:bg-gray-200`} 
                  aria-label={isListening ? "إيقاف التسجيل" : "بدء التسجيل"}
                >
                  <MicrophoneIcon className="w-7 h-7 text-black" />
                </button>
                <button 
                  onClick={toggleCallScreen} 
                  className="p-4 rounded-full bg-gray-100 hover:bg-gray-200" 
                  aria-label="إغلاق المكالمة"
                >
                  <XMarkIcon className="w-7 h-7 text-black" />
                </button>
              </div>
            </div>
          </div>
        ) : isResponseScreen ? (
          <div className="flex flex-col flex-grow px-4 pt-6" dir={selectedVoice?.lang.startsWith('ar') ? 'rtl' : 'ltr'}>
            <div className="flex items-center justify-between mb-8">
              <h2 className="text-2xl font-bold text-[#003664]">BeeTee</h2>
              <div className="relative group">
                <button onClick={newChat} className="bg-gray-100 p-2 rounded-full hover:bg-[#003664]/20 transition text-[#003664]" aria-label="محادثة جديدة">
                  <ArrowPathIcon className="w-5 h-5" />
                </button>
                <div className="absolute top-full mt-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
                  محادثة جديدة
                </div>
              </div>
            </div>
            <div className="flex flex-col gap-3 overflow-y-auto flex-grow pb-4 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
              {messages.map((msg, index) => (
                <div key={index} className={`max-w-[75%] w-fit px-4 py-3 text-sm break-words shadow-sm ${msg.type === "userMsg" ? "bg-[#003664] text-white self-end rounded-t-xl rounded-bl-xl" : "bg-gray-200 text-black self-start rounded-t-xl rounded-br-xl"}`}>
                  {msg.text}
                  {msg.image && msg.type === "userMsg" && (
                    <div className="mt-2"><img src={msg.image} alt="صورة المستخدم" className="rounded-lg max-w-xs max-h-48 object-contain"/></div>
                  )}
                </div>
              ))}
              {isLoading && (
                <div className="self-start flex items-center gap-2 bg-gray-200 text-black rounded-t-xl rounded-br-xl px-4 py-3 max-w-[75%] w-fit shadow-sm">
                  <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse delay-75"></div>
                  <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse delay-150"></div>
                  <div className="w-2 h-2 bg-gray-500 rounded-full animate-pulse delay-300"></div>
                </div>
              )}
            </div>
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center flex-grow px-4">
            <h2 className="text-4xl font-bold text-[#003664] mb-8">BeeTee</h2>
            <div className="w-full max-w-[700px] mb-3 flex items-end">
              <div className={`flex items-center border-2 ${isListening ? 'border-red-500 ring-2 ring-red-200' : 'border-[#003664]'} rounded-full px-3 py-2 relative transition-all flex-grow`}>
                <div className="flex items-center space-x-2">
                  <label htmlFor="imageInput" className="p-2 cursor-pointer hover:bg-gray-100 rounded-full" aria-label="رفع صورة">
                    <CameraIcon className="w-6 h-6 text-[#003664]" />
                  </label>
                  <input type="file" accept="image/*" onChange={handleImageUpload} className="hidden" id="imageInput" />
                  <button onClick={handleToggleListening} className={`p-2 hover:bg-gray-100 rounded-full ${isListening ? 'bg-red-50' : ''}`} aria-label={isListening ? "إيقاف الاستماع" : "بدء إدخال صوتي"}>
                    <MicrophoneIcon className={`w-6 h-6 ${isListening ? 'text-red-600 animate-pulse' : 'text-[#003664]'}`} />
                  </button>
                </div>
                <textarea 
                  value={message} 
                  onChange={handleInputChange} 
                  className="flex-1 bg-transparent outline-none resize-none py-[12px] px-3 text-base placeholder-gray-500" 
                  placeholder={isListening ? "جاري الاستماع..." : (selectedVoice?.lang.startsWith('ar') ? "اكتب رسالتك أو تحدث..." : "اكتب أو تحدث...")} 
                  disabled={isListening} 
                  rows="2" 
                  style={{ minHeight: '60px', maxHeight: '150px', overflowY: 'auto', lineHeight: '1.5' }} 
                  onKeyPress={(e) => { if (e.key === 'Enter' && !e.shiftKey && (message.trim() || selectedImage)) { e.preventDefault(); hitRequest(); }}}
                />
                <div className="flex items-center space-x-2 pr-2">
                  {isLoading && !isListening ? (
                    <ArrowPathIcon className="w-6 h-6 text-gray-500 animate-spin" />
                  ) : !isListening && (message.trim() || selectedImage) ? (
                    <button onClick={hitRequest} className="p-2 hover:bg-gray-100 rounded-full" aria-label="إرسال الرسالة">
                      <IoSend className="w-6 h-6 text-[#003664]" />
                    </button>
                  ) : (
                    <div className="w-6 h-6 p-2"></div>
                  )}
                  <div className="relative group">
                    <button 
                      onClick={handleToggleMute} 
                      className="p-2 text-[#003664]" 
                      aria-label={isMuted ? "إلغاء الكتم" : "كتم"}
                    >
                      {isMuted ? <SpeakerXMarkIcon className="w-6 h-6" /> : <SpeakerWaveIcon className="w-6 h-6" />}
                    </button>
                    <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                      {isMuted ? 
                        (selectedVoice?.lang.startsWith('ar') ? 'إلغاء كتم الصوت' : "Unmute") : 
                        (selectedVoice?.lang.startsWith('ar') ? 'كتم الصوت' : "Mute")
                      }
                    </div>
                  </div>
                  <div className="relative group">
                    <button 
                      onClick={toggleCallScreen} 
                      className="p-2 text-[#003664]" 
                      aria-label="مكالمة صوتية"
                    >
                      <SoundWaveIcon className="w-6 h-6" />
                    </button>
                    <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                      {selectedVoice?.lang.startsWith('ar') ? 'مكالمة صوتية' : 'Voice call'}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {!isCallScreen && (
          <div className="w-full px-4 py-4 bg-white border-t border-gray-200 sticky bottom-0">
            {selectedImage && (
              <div className="max-w-[700px] mx-auto mb-2 flex justify-center items-center relative">
                <img src={selectedImage} alt="معاينة" className="max-h-24 rounded-lg border border-gray-300" />
                <button onClick={removeImagePreview} className="absolute top-0 right-0 -mt-2 -mr-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold hover:bg-red-700" aria-label="إزالة الصورة">X</button>
              </div>
            )}
            {!isResponseScreen && selectedImage && (
              <div className="max-w-[700px] mx-auto mb-3 flex items-end">
                <div className={`flex items-center border-2 ${isListening ? 'border-red-500 ring-2 ring-red-200' : 'border-[#003664]'} rounded-full px-3 py-2 relative transition-all flex-grow`}>
                  <div className="flex items-center space-x-2">
                    <label htmlFor="imageInput" className="p-2 cursor-pointer hover:bg-gray-100 rounded-full" aria-label="رفع صورة">
                      <CameraIcon className="w-6 h-6 text-[#003664]" />
                    </label>
                    <input type="file" accept="image/*" onChange={handleImageUpload} className="hidden" id="imageInput" />
                    <button onClick={handleToggleListening} className={`p-2 hover:bg-gray-100 rounded-full ${isListening ? 'bg-red-50' : ''}`} aria-label={isListening ? "إيقاف الاستماع" : "بدء إدخال صوتي"}>
                      <MicrophoneIcon className={`w-6 h-6 ${isListening ? 'text-red-600 animate-pulse' : 'text-[#003664]'}`} />
                    </button>
                  </div>
                  <textarea 
                    value={message} 
                    onChange={handleInputChange} 
                    className="flex-1 bg-transparent outline-none resize-none py-[12px] px-3 text-base placeholder-gray-500" 
                    placeholder={isListening ? "جاري الاستماع..." : (selectedVoice?.lang.startsWith('ar') ? "اكتب رسالتك أو تحدث..." : "اكتب أو تحدث...")} 
                    disabled={isListening} 
                    rows="2" 
                    style={{ minHeight: '60px', maxHeight: '150px', overflowY: 'auto', lineHeight: '1.5' }} 
                    onKeyPress={(e) => { if (e.key === 'Enter' && !e.shiftKey && (message.trim() || selectedImage)) { e.preventDefault(); hitRequest(); }}}
                  />
                  <div className="flex items-center space-x-2 pr-2">
                    {isLoading && !isListening ? (
                      <ArrowPathIcon className="w-6 h-6 text-gray-500 animate-spin" />
                    ) : !isListening && (message.trim() || selectedImage) ? (
                      <button onClick={hitRequest} className="p-2 hover:bg-gray-100 rounded-full" aria-label="إرسال الرسالة">
                        <IoSend className="w-6 h-6 text-[#003664]" />
                      </button>
                    ) : (
                      <div className="w-6 h-6 p-2"></div>
                    )}
                    <div className="relative group">
                      <button 
                        onClick={handleToggleMute} 
                        className="p-2 text-[#003664]" 
                        aria-label={isMuted ? "إلغاء الكتم" : "كتم"}
                      >
                        {isMuted ? <SpeakerXMarkIcon className="w-6 h-6" /> : <SpeakerWaveIcon className="w-6 h-6" />}
                      </button>
                      <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                        {isMuted ? 
                          (selectedVoice?.lang.startsWith('ar') ? 'إلغاء كتم الصوت' : "Unmute") : 
                          (selectedVoice?.lang.startsWith('ar') ? 'كتم الصوت' : "Mute")
                        }
                      </div>
                    </div>
                    <div className="relative group">
                      <button 
                        onClick={toggleCallScreen} 
                        className="p-2 text-[#003664]" 
                        aria-label="مكالمة صوتية"
                      >
                        <SoundWaveIcon className="w-6 h-6" />
                      </button>
                      <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                        {selectedVoice?.lang.startsWith('ar') ? 'مكالمة صوتية' : 'Voice call'}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}
            {isResponseScreen && (
              <div className="max-w-[600px] mx-auto mb-3 flex items-end">
                <div className={`flex items-center border-2 ${isListening ? 'border-red-500 ring-2 ring-red-200' : 'border-[#003664]'} rounded-full px-2 py-1 relative transition-all flex-grow`}>
                  <div className="flex items-center space-x-2">
                    <label htmlFor="imageInput" className="p-2 cursor-pointer hover:bg-gray-100 rounded-full" aria-label="رفع صورة">
                      <CameraIcon className="w-5 h-5 sm:w-6 sm:h-6 text-[#003664]" />
                    </label>
                    <input type="file" accept="image/*" onChange={handleImageUpload} className="hidden" id="imageInput" />
                    <button onClick={handleToggleListening} className={`p-2 hover:bg-gray-100 rounded-full ${isListening ? 'bg-red-50' : ''}`} aria-label={isListening ? "إيقاف الاستماع" : "بدء إدخال صوتي"}>
                      <MicrophoneIcon className={`w-5 h-5 sm:w-6 sm:h-6 ${isListening ? 'text-red-600 animate-pulse' : 'text-[#003664]'}`} />
                    </button>
                  </div>
                  <textarea 
                    value={message} 
                    onChange={handleInputChange} 
                    className="flex-1 bg-transparent outline-none resize-none py-[10px] px-2 text-sm sm:text-base placeholder-gray-500" 
                    placeholder={isListening ? "جاري الاستماع..." : (selectedVoice?.lang.startsWith('ar') ? "اكتب رسالتك أو تحدث..." : "اكتب أو تحدث...")} 
                    disabled={isListening} 
                    rows="1" 
                    style={{ minHeight: '40px', maxHeight: '120px', overflowY: 'auto', lineHeight: '1.5' }} 
                    onKeyPress={(e) => { if (e.key === 'Enter' && !e.shiftKey && (message.trim() || selectedImage)) { e.preventDefault(); hitRequest(); }}}
                  />
                  <div className="flex items-center space-x-2 pr-2">
                    {isLoading && !isListening ? (
                      <ArrowPathIcon className="w-5 h-5 sm:w-6 sm:h-6 text-gray-500 animate-spin" />
                    ) : !isListening && (message.trim() || selectedImage) ? (
                      <button onClick={hitRequest} className="p-2 hover:bg-gray-100 rounded-full" aria-label="إرسال الرسالة">
                        <IoSend className="w-5 h-5 sm:w-6 sm:h-6 text-[#003664]" />
                      </button>
                    ) : (
                      <div className="w-5 h-5 sm:w-6 sm:h-6 p-2"></div>
                    )}
                    <div className="relative group">
                      <button 
                        onClick={handleToggleMute} 
                        className="p-2 text-[#003664]" 
                        aria-label={isMuted ? "إلغاء الكتم" : "كتم"}
                      >
                        {isMuted ? <SpeakerXMarkIcon className="w-5 h-5 sm:w-6 sm:h-6" /> : <SpeakerWaveIcon className="w-5 h-5 sm:w-6 sm:h-6" />}
                      </button>
                      <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                        {isMuted ? 
                          (selectedVoice?.lang.startsWith('ar') ? 'إلغاء كتم الصوت' : "Unmute") : 
                          (selectedVoice?.lang.startsWith('ar') ? 'كتم الصوت' : "Mute")
                        }
                      </div>
                    </div>
                    <div className="relative group">
                      <button 
                        onClick={toggleCallScreen} 
                        className="p-2 text-[#003664]" 
                        aria-label="مكالمة صوتية"
                      >
                        <SoundWaveIcon className="w-5 h-5 sm:w-6 sm:h-6" />
                      </button>
                      <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10">
                        {selectedVoice?.lang.startsWith('ar') ? 'مكالمة صوتية' : 'Voice call'}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}
            <p className="text-gray-500 text-center text-xs sm:text-sm mt-4">BeeTee is developed by Sohaila Ashraf using the OpenRouter API.</p>
          </div>
        )}
      </div>
    </>
  );
};

export default ChatBot;