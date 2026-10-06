EMIL OMR + AUDIO BACKEND FOR RAILWAY

Upload the files in this folder to the GitHub repository used by Railway.
The Dockerfile must be in the repository root so Railway detects it automatically.

After Railway deploys successfully:
1. Open the service Settings.
2. Networking -> Generate Domain.
3. Copy the generated https://... URL.
4. In Netlify, add environment variable OMR_SERVICE_URL with that URL.
5. Redeploy the Netlify site.

This backend supports:
- Audiveris-based printed sheet music OMR
- Audio melody/chord analysis
- Existing frontend AI assistant remains separate
