const express = require("express");
const path = require("path");

if (!process.env.PORT) {
    throw new Error("Please specify the port number for the HTTP server with the environment variable PORT.");
}

const PORT = process.env.PORT;

//
// Application entry point.
//
async function main() {
    const app = express();

    //
    // Enables JSON body parsing for HTTP requests.
    //
    app.use(express.json());

    // Serve the ad images from this microservice (stored in ./public).
    app.use(express.static(path.join(__dirname, "..", "public")));

    // HTTP GET route to retrieve ads.
    app.get("/ads", async (req, res) => {
        res.json({
            ads: [
                {
                    name: "Shopee",
                    url: "https://shopee.co.th/",
                    imagePath: "/images/shopee.svg",
                },
                {
                    name: "Lazada",
                    url: "https://www.lazada.co.th/",
                    imagePath: "/images/lazada.svg",
                },
                {
                    name: "Kaidee",
                    url: "https://www.kaidee.com/",
                    imagePath: "/images/kaidee.svg",
                },
            ],
        });
    });

    //
    // Starts the HTTP server.
    //
    app.listen(PORT, () => {
        console.log("Microservice online.");
    });
}

main()
    .catch(err => {
        console.error("Microservice failed to start.");
        console.error(err && err.stack || err);
    });