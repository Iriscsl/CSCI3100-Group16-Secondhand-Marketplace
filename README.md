# CSCI3100-Group16-Secondhand-Marketplace

CUHK Secondhand Marketplace — a Rails 8 web app for buying and selling second-hand items within the CUHK community.

## Ruby Version

See `.ruby-version`

## System Dependencies

- Ruby (see `.ruby-version`)
- PostgreSQL (hosted on [Supabase](https://supabase.com))
- Node.js (for assets)

## Configuration

1. Copy environment variables:
   ```bash
   cp .env.example .env.development
   ```
2. Fill in the Supabase database credentials (from **Supabase Dashboard → Project Settings → Database → Connection string**, use the **Session/Transaction mode pooler**):
   - `DATABASE_HOST` — pooler host, e.g. `aws-0-ap-southeast-1.pooler.supabase.com`
   - `DATABASE_PORT` — `6543`
   - `DATABASE_NAME` — `postgres`
   - `DATABASE_USERNAME` — `postgres.YOUR_PROJECT_REF`
   - `DATABASE_PASSWORD` — your Supabase database password
   - `DATABASE_SSLMODE` — `require`
   - `DATABASE_PREPARED_STATEMENTS` — `false`

3. Set the following for email delivery (optional):
   - `GMAIL_USERNAME` — your Gmail address
   - `GMAIL_APP_PASSWORD` — a Gmail App Password

   If these are not set, emails will open in the browser via `letter_opener` in development.

4. Set the following for Stripe (optional):
   - `STRIPE_SECRET_KEY`
   - `STRIPE_PUBLISHABLE_KEY`

## Database Setup

```bash
bin/rails db:migrate db:seed
```

### Seed Data

Running `db:seed` creates two pre-confirmed users and sample items:

| Email | Password | Name |
|---|---|---|
| `1155000001@link.cuhk.edu.hk` | `password123` | Alice Chan |
| `1155000002@link.cuhk.edu.hk` | `password123` | Bob Wong |

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