document.getElementById('openSandbox').addEventListener('click', () => {
    chrome.runtime.sendNativeMessage('com.your_company.sandbox_opener', {}, (response) => {
      console.log(response);
    });
  });
  