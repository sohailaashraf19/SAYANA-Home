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

const SoundWaveIcon = () => (
  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M2 12h4M18 12h4M8 6v12M16 6v12" />
  </svg>
);

const VoiceSettingsIcon = () => (
  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M4 12h16M12 4v16" />
  </svg>
);

const ChatBot = () => {
  const [isLandingScreen, setIsLandingScreen] = useState(true);
  const [inputValue, setInputValue] = useState("");
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
  const [showVoiceDropdown, setShowVoiceDropdown] = useState(false);
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
        setInputValue(transcript);
        if (transcript.trim() || selectedImage) {
          handleSend(transcript.trim());
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
    if (e.target.value.length <= 500) setInputValue(e.target.value);
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

  // 👇 هذا هو الجزء المهم لجعل البوت يستوعب كل السياق وليس الرسالة الأخيرة فقط
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

      // 👇 بناء كل المحادثة السابقة لإرسالها إلى الـ API
      const history = [];
      for (const msg of messages) {
        if (msg.type === "userMsg") {
          history.push({ role: "user", content: msg.text });
        } else if (msg.type === "responseMsg") {
          history.push({ role: "assistant", content: msg.text });
        }
      }
      // أضف الرسالة الجديدة
      history.push({ role: "user", content: combinedMessageText });

      const body = JSON.stringify({
        model: modelToUse,
        messages: [
          {
            role: 'system',
            content:
              "أنت الآن تتحدث كأنك إنسان طبيعي وودود، وتتكلم بطريقة مرحة وبسيطة، لا تذكر أبدًا أنك روبوت أو مساعد افتراضي أو ذكاء اصطناعي، وردودك دائمًا طبيعية كأنك صديق فعلاً."
          },
          ...history
        ],
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
        setIsLoading(false);
        throw new Error("حدث خطأ في الاتصال بالخدمة. حاول مرة أخرى لاحقًا.");
      }

      const data = await response.json();

      if (!data.choices || data.choices.length === 0 || !data.choices[0].message || !data.choices[0].message.content) {
        setIsLoading(false);
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
      setInputValue("");
      setSelectedImage(null);
      speakText(botReplyCleaned);

    } catch (error) {
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
  }, [isLoading, selectedImage, speakText, messages]);

  const handleSend = (value) => {
    const text = (typeof value === "string" ? value : inputValue).trim();
    if (text || selectedImage) {
      if (isLandingScreen) setIsLandingScreen(false);
      generateResponse(text);
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
      setInputValue("");
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
    setInputValue("");
    setSelectedImage(null);
    setIsLoading(false);
    setIsListening(false);
    setIsCallScreen(false);
    setVoiceAnimation(false);
    if (window.speechSynthesis) window.speechSynthesis.cancel();
    if (recognitionRef.current && isListening) recognitionRef.current.stop();
  };

  const toggleCallScreen = () => {
    setIsCallScreen(true);
    setShowVoiceDropdown(false);
    if (isListening) recognitionRef.current?.stop();
    if (window.speechSynthesis.speaking) window.speechSynthesis.cancel();
  };

  const closeCallScreen = () => {
    setIsCallScreen(false);
    if (isListening) recognitionRef.current?.stop();
    if (window.speechSynthesis.speaking) window.speechSynthesis.cancel();
  };

  // زر اختيار الصوت أعلى يمين الصفحة
  const VoiceSelectorButton = (
    <div className="fixed top-4 right-4 z-50">
      <div className="relative group">
        <button
          className="p-3 rounded-full bg-gray-100 hover:bg-gray-200"
          aria-label="اختر صوت النطق"
          onClick={() => setShowVoiceDropdown(v => !v)}
          type="button"
        >
          <VoiceSettingsIcon />
        </button>
        {showVoiceDropdown && (
          <select
            id="voiceSelect"
            value={selectedVoice ? selectedVoice.name : ""}
            onChange={(e) => {
              const voice = voices.find(v => v.name === e.target.value);
              setSelectedVoice(voice);
              setShowVoiceDropdown(false);
            }}
            className="absolute top-full right-0 mt-2 bg-white border border-gray-300 rounded shadow-lg z-50 min-w-[200px] max-h-60 overflow-auto p-2"
            aria-label="اختر صوت النطق"
            autoFocus
            onBlur={() => setShowVoiceDropdown(false)}
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
        )}
        <div className="absolute top-full mt-2 right-0 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
          اختر الصوت
        </div>
      </div>
    </div>
  );

  // Unified InputBox (بدون زر اختيار الصوت هنا)
  const InputBox = (
    <div className="w-full max-w-[700px] mx-auto flex items-end" style={{height: 70}}>
      <div className={`flex items-center border-2 ${isListening ? 'border-red-500 ring-2 ring-red-200' : 'border-[#003664]'} rounded-full px-3 py-2 relative transition-all flex-grow`} style={{height: 55}}>
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
          value={inputValue} 
          onChange={handleInputChange} 
          className="flex-1 bg-transparent outline-none resize-none py-[12px] px-3 text-base placeholder-gray-500" 
          placeholder={isListening ? "جاري الاستماع..." : (selectedVoice?.lang.startsWith('ar') ? "اكتب رسالتك أو تحدث..." : "اكتب أو تحدث...")} 
          disabled={isListening} 
          rows={1}
          style={{ minHeight: '30px', maxHeight: '56px', overflowY: 'auto', lineHeight: '1.5' }} 
          onKeyPress={(e) => { if (e.key === 'Enter' && !e.shiftKey && (inputValue.trim() || selectedImage)) { e.preventDefault(); handleSend(); }}}
        />
        <div className="flex items-center space-x-2 pr-2">
          {isLoading && !isListening ? (
            <ArrowPathIcon className="w-6 h-6 text-gray-500 animate-spin" />
          ) : !isListening && (inputValue.trim() || selectedImage) ? (
            <button onClick={() => handleSend()} className="p-2 hover:bg-gray-100 rounded-full" aria-label="إرسال الرسالة">
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
  );

  return (
    <>
      <style>
        {`
          @keyframes grow {
            0% { transform: scale(0.5); }
            100% { transform: scale(1); }
          }
        `}
      </style>
      {VoiceSelectorButton}
      <div className="w-screen h-screen min-h-0 bg-[#FBFBFB] text-black flex flex-col font-sans overflow-hidden">
        <div id="error-message-display" className="fixed top-4 left-1/2 -translate-x-1/2 bg-red-600 text-white px-4 py-2 rounded-md shadow-lg z-50 hidden transition-opacity duration-300 opacity-90">
          رسالة الخطأ هنا
        </div>
        {isCallScreen ? (
          <div className="flex flex-col items-center justify-center flex-1 bg-white text-black p-4 relative" style={{minHeight: 0}}>
            <div className="flex flex-col items-center justify-center flex-1 min-h-0">
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
                  onClick={closeCallScreen} 
                  className="p-4 rounded-full bg-gray-100 hover:bg-gray-200" 
                  aria-label="إغلاق المكالمة"
                >
                  <XMarkIcon className="w-7 h-7 text-black" />
                </button>
              </div>
            </div>
          </div>
        ) : isLandingScreen ? (
          <div className="flex flex-col items-center justify-center flex-1 px-4 min-h-0">
            <h1 className="text-4xl font-bold text-[#003664] mb-6">Welcome to BeeTee</h1>
            <p className="mb-6 text-lg text-gray-600">Start a new conversation by typing your message below:</p>
            {InputBox}
            {selectedImage && (
              <div className="max-w-[700px] mx-auto mb-2 flex justify-center items-center relative">
                <img src={selectedImage} alt="معاينة" className="max-h-24 rounded-lg border border-gray-300" />
                <button onClick={removeImagePreview} className="absolute top-0 right-0 -mt-2 -mr-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold hover:bg-red-700" aria-label="إزالة الصورة">X</button>
              </div>
            )}
          </div>
        ) : isResponseScreen ? (
          <div className="flex flex-col flex-1 px-4 pt-6 min-h-0" dir={selectedVoice?.lang.startsWith('ar') ? 'rtl' : 'ltr'}>
            <div className="flex items-center justify-between mb-8">
              <div className="relative group flex-shrink-0">
                <button onClick={newChat} className="bg-gray-100 p-2 rounded-full hover:bg-[#003664]/20 transition text-[#003664]" aria-label="محادثة جديدة">
                  <ArrowPathIcon className="w-5 h-5" />
                </button>
                <div className="absolute top-full mt-2 left-1/2 -translate-x-1/2 bg-black text-white text-xs rounded px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
                  محادثة جديدة
                </div>
              </div>
              <div className="flex-1 flex justify-center">
                <h2 className="text-2xl font-bold text-[#003664]">BeeTee</h2>
              </div>
            </div>
            <div className="flex flex-col gap-3 overflow-y-auto flex-1 pb-4 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100 min-h-0">
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
            {InputBox}
            {selectedImage && (
              <div className="max-w-[700px] mx-auto mb-2 flex justify-center items-center relative">
                <img src={selectedImage} alt="معاينة" className="max-h-24 rounded-lg border border-gray-300" />
                <button onClick={removeImagePreview} className="absolute top-0 right-0 -mt-2 -mr-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold hover:bg-red-700" aria-label="إزالة الصورة">X</button>
              </div>
            )}
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center flex-1 px-4 min-h-0">
            <h2 className="text-4xl font-bold text-[#003664] mb-8">BeeTee</h2>
            {InputBox}
            {selectedImage && (
              <div className="max-w-[700px] mx-auto mb-2 flex justify-center items-center relative">
                <img src={selectedImage} alt="معاينة" className="max-h-24 rounded-lg border border-gray-300" />
                <button onClick={removeImagePreview} className="absolute top-0 right-0 -mt-2 -mr-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold hover:bg-red-700" aria-label="إزالة الصورة">X</button>
              </div>
            )}
          </div>
        )}
        <div className="w-full text-center py-2 text-xs text-gray-400 bg-[#FBFBFB] border-t border-gray-200 flex-shrink-0">
          BeeTee is developed by Sohaila Ashraf using OpenRouter API
        </div>
      </div>
    </>
  );
};

export default ChatBot;