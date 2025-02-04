
# **Movie Streaming Platform**

This is a basic movie streaming platform built using **Astro** for static site generation and dynamic routing. The platform integrates video streaming functionality with quality selection and dynamic routing for each movie.

## **Features**

- **Dynamic Routing:** Allows users to access movies via dynamic paths based on movie IDs.
- **Video Streaming:** Allows video playback in different qualities (e.g., 1080p, 720p, 480p).
- **Interactive Quality Selector:** Users can select video quality (e.g., 1080p, 720p, 480p) dynamically while watching.
- **Responsive Design:** Optimized for all screen sizes, ensuring a smooth viewing experience on mobile, tablet, and desktop.

## **Setup Instructions**

### **1. Clone the Repository**
Clone the repository to your local machine to get started:

```bash
git clone <repo-url>
cd <project-folder>
```

### **2. Install Dependencies**

Install the required dependencies using npm:

```bash
npm install
```

### **3. Run the Development Server**

Start the local development server:

```bash
npm run dev
```

This will start the project and you can view it by navigating to `http://localhost:3000` in your browser.

### **4. Build the Project**

If you want to build the project for production, run:

```bash
npm run build
```

This will generate the production-ready files in the `dist/` folder.

### **5. Customize**

- Add new movies by modifying the mock movie data or by connecting to a movie database or API.
- Modify the video URLs and add additional quality options.
- Adjust the layout and styling in `src/styles/` or within component files.

## **Folder Structure**

```
/
├── src/
│   ├── components/
│   │   └── VideoPlayer.astro   # Video streaming component
│   ├── pages/
│   │   └── video/             # Dynamic route for movie streaming
│   └── styles/                # Custom styles
├── public/                    # Static assets like images and videos
├── astro.config.mjs           # Astro configuration file
└── package.json               # Project dependencies and scripts
```

## **Technologies Used**

- **Astro:** Static site generator for fast and optimized front-end development.
- **Tailwind CSS:** Utility-first CSS framework for styling.
- **Node.js:** Backend server for API handling and dynamic route processing.
- **React (Optional):** You can integrate React components for more complex interactivity, such as video quality selection.

## **Troubleshooting**

- **Error: Missing getStaticPaths()**: Ensure that you’ve correctly defined `getStaticPaths()` for your dynamic route, especially for movies with unique paths.
- **CORS Issues:** If videos or other assets are served from an external server, ensure proper CORS headers are set up.

## **License**

This project is open-source and available under the [MIT License](LICENSE).

