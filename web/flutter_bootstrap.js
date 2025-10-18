{{flutter_js}}
{{flutter_build_config}}

// Add error handling for Flutter web initialization
window.addEventListener('error', function(e) {
  console.warn('Flutter initialization error:', e.error);
});

// Configure Flutter web with error handling
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine({
        // Use HTML renderer to avoid CanvasKit font issues
        renderer: "html",
        // Add comprehensive font fallbacks for better character coverage
        fontFallbacks: [
          "Roboto", 
          "Noto Sans", 
          "Noto Color Emoji",
          "Arial", 
          "Helvetica", 
          "sans-serif",
          "Apple Color Emoji",
          "Segoe UI Emoji",
          "Segoe UI Symbol"
        ]
      });
      
      await appRunner.runApp();
      
      // Notify that Flutter has loaded
      window.dispatchEvent(new Event('flutter-first-frame'));
    } catch (error) {
      console.error('Failed to initialize Flutter app:', error);
      
      // Show error message to user
      document.body.innerHTML = `
        <div style="display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial, sans-serif;">
          <div style="text-align: center;">
            <h2>Failed to load application</h2>
            <p>Please refresh the page to try again.</p>
            <button onclick="window.location.reload()" style="padding: 10px 20px; font-size: 16px;">Refresh</button>
          </div>
        </div>
      `;
    }
  }
});
