# CSCI3100-Group16-Secondhand-Marketplace

CUHK Secondhand Marketplace — a Rails 8 web app for buying and selling second-hand items within the CUHK community.

## Ruby Version

See `.ruby-version`

## System Dependencies

- PostgreSQL
- Node.js (for assets)

## Configuration

1. Copy environment variables:
   ```bash
   cp .env.example .env
   ```
2. Set the following in `.env` (optional, for email delivery):
   - `GMAIL_USERNAME` — your Gmail address
   - `GMAIL_APP_PASSWORD` — a Gmail App Password

   If these are not set, emails will open in the browser via `letter_opener` in development.

## Database Setup

```bash
bin/rails db:create db:migrate db:seed
```

## Running the App

```bash
bin/dev
```

Then visit `http://localhost:3000`.

## How to Run the Test Suite

```bash
bin/rails test
```

## Daily Digest Email

A daily digest email is sent to all registered users summarising new marketplace listings from the last 24 hours.

### Architecture

| Component | File | Purpose |
|---|---|---|
| **Mailer** | `app/mailers/item_digest_mailer.rb` | Builds and sends the digest email |
| **HTML template** | `app/views/item_digest_mailer/daily_digest.html.erb` | Rich HTML email layout |
| **Text template** | `app/views/item_digest_mailer/daily_digest.text.erb` | Plain-text fallback |
| **Background job** | `app/jobs/daily_digest_job.rb` | Loops through all users and sends emails |
| **Rake task** | `lib/tasks/daily_digest.rake` | CLI trigger: `rails digest:send` |
| **Cron schedule** | `config/schedule.rb` | Runs the rake task daily at 8:00 AM (via `whenever` gem) |
| **Web preview** | `app/controllers/digests_controller.rb` + `app/views/digests/show.html.erb` | In-app digest page at `/digest` |
| **SMTP config** | `config/initializers/gmail_smtp.rb` | Gmail SMTP settings |

### Manual Trigger

```bash
bin/rails digest:send
```

### Cron Setup (via `whenever`)

Preview the generated crontab:
```bash
bundle exec whenever
```

Write it to the system crontab:
```bash
bundle exec whenever --update-crontab
```

Clear the crontab entry:
```bash
bundle exec whenever --clear-crontab
```