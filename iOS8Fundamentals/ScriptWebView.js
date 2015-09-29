

function onOpenCamera() {
    console.log('Message from console');
    window.webkit.messageHandlers.Observe.postMessage('Opening cammera');
}