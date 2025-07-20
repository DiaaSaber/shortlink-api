# ShortLink API - A URL Shortening Service

A simple and robust URL shortening service built with Ruby on Rails and deployed on Heroku. This application provides API endpoints to encode long URLs into short ones and decode them back, and is fully containerized with Docker for easy local setup and testing.

**Live Demo URL:** [https://oivan-url-shortener-2365a0eff176.herokuapp.com](https://www.google.com/search?q=https://oivan-url-shortener-2365a0eff176.herokuapp.com "null")

## Table of Contents

-   [Features](#features)
-   [Tech Stack](#tech-stack)
-   [API Endpoints](#api-endpoints)
-   [Getting Started (Docker)](#getting-started-docker)
-   [Running the Tests](#running-the-tests)
-   [Security Considerations](#security-considerations)
-   [Scalability Plan](#scalability-plan)
    

## Features

-   Encodes long URLs into unique, multi-character short codes.
    
-   Decodes short codes back to their original long URLs.
    
-   Provides a direct HTTP redirect for shortened links when visited in a browser.
    
-   JSON-based API for programmatic use.
    
-   100% test coverage with RSpec and SimpleCov.
    
-   Containerized with Docker for a reproducible and easy-to-run local environment.
    
-   Continuous deployment to Heroku via GitHub.
    

## Tech Stack

-   **Language:** Ruby 3.3.0
    
-   **Framework:** Ruby on Rails 7.1
    
-   **Database:** PostgreSQL
    
-   **Containerization:** Docker & Docker Compose
    
-   **Deployment:** Heroku
    
-   **Testing:** RSpec & SimpleCov
    

## API Endpoints

### 1\. Encode a URL

Creates a new short URL.

-   **URL:** `https://oivan-url-shortener-2365a0eff176.herokuapp.com/api/v1/encode`
    
-   **Method:** `POST`
    
-   **Content-Type:** `application/json`
    
-   **Body Example:**
    
        {
          "url": "https://www.google.com/search?q=ruby+on+rails"
        }
        
    
-   **Curl Example:**
    
        curl -X POST \
          https://oivan-url-shortener-2365a0eff176.herokuapp.com/api/v1/encode \
          -H 'Content-Type: application/json' \
          -d '{"url": "https://www.google.com/search?q=ruby+on+rails"}'
        
    
-   **Success Response (200 OK):**
    
        {
          "short_url": "https://oivan-url-shortener-2365a0eff176.herokuapp.com/6lCi2"
        }
        
    

### 2\. Decode a Short URL

Retrieves the original long URL via the API.

-   **URL:** `https://oivan-url-shortener-2365a0eff176.herokuapp.com/api/v1/decode/:short_code`
    
-   **Method:** `GET`
    
-   **Curl Example:**
    
        curl https://oivan-url-shortener-2365a0eff176.herokuapp.com/api/v1/decode/6lCi2
        
    
-   **Success Response (200 OK):**
    
        {
          "long_url": "https://www.google.com/search?q=ruby+on+rails"
        }
        
    

### 3\. Redirect

Following a short link in a browser (or with `curl -L`) will result in a `301 Moved Permanently` redirect to the original URL.

-   **URL:** `https://oivan-url-shortener-2365a0eff176.herokuapp.com/:short_code`
    
-   **Curl Example:**
    
        curl -L https://oivan-url-shortener-2365a0eff176.herokuapp.com/6lCi2
        
    

## Getting Started (Docker)

This application is fully containerized. The only prerequisite is to have **Docker** and **Docker Compose** installed.

1.  **Clone the repository:**
    
        git clone https://github.com/DiaaSaber/shortlink-api.git
        cd shortlink-api
        
    
2.  **Build** and Run the **Application:**
    
        docker-compose up -d uild
        
    
    The application will be running in development mode at `http://localhost:3000`. The database will be created and migrated automatically on the first.
    

## Running the Tests

To run the full RSpec test suite and generate a coverage report:

1.  **Ensure the containers are running:**
    
        docker-compose up -d
        
    
2.  **Execute the test suite:**
    
        docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
        
    
    The coverage report will be generated in the `coverage/` directory.
    

## Security Considerations

1.  **Malicious Link Obfuscation (Phishing/Malware):**
    
    -   **Vulnerability:** An attacker could use this service to shorten a link to a malicious website, hiding the dangerous destination from unsuspecting users.
        
    -   **Mitigation:** In a production environment, a check against a safe browsing API (like the [Google Safe Browsing API](https://safebrowsing.google.com/ "null")) should be implemented. Before a URL is saved, it would be sent to the API to ensure it is not a known malicious site.
        
2.  **Denial of Service (DoS) Attack:**
    
    -   **Vulnerability:** An attacker could spam the `/encode` endpoint with an infinite number of unique URLs, causing the database to grow uncontrollably and potentially exhausting server resources.
        
    -   **Mitigation:** **Rate limiting** should be implemented on the API endpoints. Using a gem like `rack-attack`, we could limit the number of requests allowed from a single IP address over a certain period (e.g., 60 requests per minute).
        

## Scalability Plan

The current implementation is simple and robust for a small scale, but would face challenges with high traffic.

1.  **Database Reads:**
    
    -   **Problem:** The `/decode` endpoint performs a database read for every request. For a very popular link, this would result in thousands of identical database queries, putting a heavy load on the database.
        
    -   **Solution:** Implement a **caching layer** using **Redis**. When a short URL is decoded, the result would be stored in the cache with a reasonable expiration time (e.g., 24 hours). Subsequent requests for the same short URL would hit the cache first, which is significantly faster and reduces database load.




