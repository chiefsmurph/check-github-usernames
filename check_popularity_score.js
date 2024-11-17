import puppeteer from 'puppeteer';  // ES import


let browser;


async function getPopularityScore(name) {
    browser = browser || await puppeteer.launch({ headless: false});
    const page = await browser.newPage();
    const searchQuery = `https://duckduckgo.com/?q=${name}`;

    // Navigate to the search engine
    await page.goto(searchQuery, { waitUntil: 'domcontentloaded' });

    // Wait for the results to load
    await page.waitForSelector('.results--main');  // Modify based on the actual element

    await new Promise(resolve => setTimeout(resolve, 5000));

    // Extract the search results
    const resultCount = await page.evaluate(() => {
        // Count the number of results or specific elements that indicate presence
        return document.querySelectorAll('.result').length;  // Modify based on actual element
    });

    console.log(JSON.stringify({contents: await page.content(), resultCount }), null, 2)
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Calculate score based on the number of occurrences
    let score = 1;
    if (resultCount < 5) score = 1;
    else if (resultCount < 15) score = 25;
    else if (resultCount < 50) score = 50;
    else if (resultCount < 100) score = 75;
    else score = 100;

    console.log(`📈 Popularity Score for '${name}': ${score}/100`);
}

// Process names from command-line arguments
async function processNames() {
    const names = process.argv.slice(2);
    
    // Loop through the names and wait for each to finish
    for (const name of names) {
        await getPopularityScore(name);
    }

    // Close the browser

    await browser.close();
    browser = null;
}

// Call the process function
processNames();
