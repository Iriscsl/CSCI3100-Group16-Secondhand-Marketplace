# CSCI3100-Group16-Secondhand-Marketplace

CUHK Secondhand Marketplace — a Rails 8 web app for buying and selling second-hand items within the CUHK community.

---

## Table of Contents

- [Setup Guide](#setup-guide)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Database Setup](#database-setup)
  - [Running the App](#running-the-app)
- [How to Run Tests](#how-to-run-tests)
- [Implemented Features](#implemented-features)
- [SimpleCov Report](#simplecov-report)

---

## Setup Guide

### Prerequisites

- **Ruby** 3.3.8 (see `.ruby-version`)
- **PostgreSQL** (hosted on [Supabase](https://supabase.com))
- **Node.js** (for assets)
- **Bundler** (`gem install bundler`)

### Installation

```bash
git clone https://github.com/Iriscsl/CSCI3100-Group16-Secondhand-Marketplace.git
cd CSCI3100-Group16-Secondhand-Marketplace
bundle install
```

### Configuration

1. Copy the environment template:
   ```bash
   cp .env.example .env.development
   ```

2. Fill in the **Supabase database credentials** (from Supabase Dashboard → Project Settings → Database → Connection string, use the Session/Transaction mode pooler):
   - `DATABASE_HOST` — pooler host, e.g. `aws-0-ap-southeast-1.pooler.supabase.com`
   - `DATABASE_PORT` — `6543`
   - `DATABASE_NAME` — `postgres`
   - `DATABASE_USERNAME` — `postgres.YOUR_PROJECT_REF`
   - `DATABASE_PASSWORD` — your Supabase database password
   - `DATABASE_SSLMODE` — `require`
   - `DATABASE_PREPARED_STATEMENTS` — `false`

3. Set **Gmail SMTP credentials** (optional — if omitted, emails open in-browser via `letter_opener`):
   - `GMAIL_USERNAME` — your Gmail address
   - `GMAIL_APP_PASSWORD` — a Gmail App Password

4. Set **Stripe API keys** (optional — required for payment checkout):
   - `STRIPE_SECRET_KEY`
   - `STRIPE_PUBLISHABLE_KEY`

### Database Setup

```bash
bin/rails db:migrate db:seed
```

`db:seed` creates two pre-confirmed users and sample items:

| Email | Password | Name |
|---|---|---|
| `1155000001@link.cuhk.edu.hk` | `password123` | Alice Chan |
| `1155000002@link.cuhk.edu.hk` | `password123` | Bob Wong |

### Running the App

```bash
bin/dev
```

Then visit [http://localhost:3000](http://localhost:3000).

---

## How to Run Tests

### Minitest (unit & controller tests)

```bash
bin/rails test
```

### RSpec (model & request specs)

```bash
bundle exec rspec
```

### Cucumber (acceptance / BDD tests)

```bash
bundle exec cucumber
```

### All tests with coverage

SimpleCov is configured to generate a coverage report. After running the test suite, open `coverage/index.html` in your browser.

---

## Implemented Features

| Feature Name | Primary Developer | Secondary Developer | Notes |
|---|---|---|---|
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |

---

## SimpleCov Report

<!-- Replace the path below with the actual screenshot once generated -->
![SimpleCov Report](docs/simplecov.png)

> **To generate:** run the test suite (`bin/rails test`, `bundle exec rspec`, or `bundle exec cucumber`), then take a screenshot of `coverage/index.html` and save it as `docs/simplecov.png`.