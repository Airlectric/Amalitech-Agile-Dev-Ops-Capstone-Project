#!/bin/bash

# ============================================================
# SpendWise Database Population Script
# Targets: https://spenwise-amalitech-agile-dev-ops.onrender.com
# Creates account, logs in, and populates with transaction data
# ============================================================

BASE_URL="https://spenwise-amalitech-agile-dev-ops.onrender.com"

# User credentials
USER_NAME="Test User"
USER_EMAIL="testuser_$(date +%s)@example.com"
USER_PASSWORD="SecurePass123"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

success_count=0
fail_count=0

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
  ((success_count++))
}

log_error() {
  echo -e "${RED}[FAIL]${NC} $1"
  ((fail_count++))
}

log_info() {
  echo -e "${CYAN}[INFO]${NC} $1"
}

log_section() {
  echo ""
  echo -e "${YELLOW}========================================${NC}"
  echo -e "${YELLOW} $1${NC}"
  echo -e "${YELLOW}========================================${NC}"
}

# ----------------------------------------------------------
# 1. Health Check
# ----------------------------------------------------------
log_section "Health Check"
HEALTH=$(curl -s "$BASE_URL/health")
echo "$HEALTH" | python3 -m json.tool 2>/dev/null || echo "$HEALTH"
log_info "Health check complete"

# ----------------------------------------------------------
# 2. Register a new account
# ----------------------------------------------------------
log_section "Registering New Account"
log_info "Email: $USER_EMAIL"

REGISTER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$USER_NAME\",
    \"email\": \"$USER_EMAIL\",
    \"password\": \"$USER_PASSWORD\"
  }")

HTTP_CODE=$(echo "$REGISTER_RESPONSE" | tail -1)
BODY=$(echo "$REGISTER_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
  log_success "Account created (HTTP $HTTP_CODE)"
  echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
else
  log_error "Registration failed (HTTP $HTTP_CODE)"
  echo "$BODY"
  exit 1
fi

# ----------------------------------------------------------
# 3. Login
# ----------------------------------------------------------
log_section "Logging In"

LOGIN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$USER_EMAIL\",
    \"password\": \"$USER_PASSWORD\"
  }")

HTTP_CODE=$(echo "$LOGIN_RESPONSE" | tail -1)
BODY=$(echo "$LOGIN_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  TOKEN=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null)
  if [ -z "$TOKEN" ]; then
    log_error "Could not extract token"
    echo "$BODY"
    exit 1
  fi
  log_success "Logged in successfully"
  log_info "Token: ${TOKEN:0:30}..."
else
  log_error "Login failed (HTTP $HTTP_CODE)"
  echo "$BODY"
  exit 1
fi

AUTH_HEADER="Authorization: Bearer $TOKEN"

# ----------------------------------------------------------
# Helper: Create a transaction
# ----------------------------------------------------------
create_transaction() {
  local type="$1"
  local amount="$2"
  local category="$3"
  local description="$4"
  local date="$5"

  RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/transactions" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{
      \"type\": \"$type\",
      \"amount\": $amount,
      \"category\": \"$category\",
      \"description\": \"$description\",
      \"date\": \"$date\"
    }")

  HTTP_CODE=$(echo "$RESPONSE" | tail -1)

  if [ "$HTTP_CODE" -eq 201 ]; then
    log_success "$type | $category | \$$amount | $date | $description"
  else
    BODY=$(echo "$RESPONSE" | sed '$d')
    log_error "$type | $category | \$$amount — HTTP $HTTP_CODE: $BODY"
  fi
}

# ----------------------------------------------------------
# 4. Populate INCOME transactions
# ----------------------------------------------------------
log_section "Creating INCOME Transactions"

# --- Salary (monthly, 12 months) ---
log_info "Adding Salary income..."
create_transaction "income" 3500.00 "Salary" "Monthly salary - January" "2025-01-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - February" "2025-02-28"
create_transaction "income" 3500.00 "Salary" "Monthly salary - March" "2025-03-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - April" "2025-04-30"
create_transaction "income" 3500.00 "Salary" "Monthly salary - May" "2025-05-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - June" "2025-06-30"
create_transaction "income" 3500.00 "Salary" "Monthly salary - July" "2025-07-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - August" "2025-08-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - September" "2025-09-30"
create_transaction "income" 3500.00 "Salary" "Monthly salary - October" "2025-10-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - November" "2025-11-30"
create_transaction "income" 3500.00 "Salary" "Monthly salary - December" "2025-12-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - January 2026" "2026-01-31"
create_transaction "income" 3500.00 "Salary" "Monthly salary - February 2026" "2026-02-15"

# --- Freelance ---
log_info "Adding Freelance income..."
create_transaction "income" 800.00 "Freelance" "Website redesign for client A" "2025-01-15"
create_transaction "income" 1200.00 "Freelance" "Mobile app mockup project" "2025-02-10"
create_transaction "income" 450.00 "Freelance" "Logo design for startup" "2025-03-22"
create_transaction "income" 2000.00 "Freelance" "E-commerce site development" "2025-05-05"
create_transaction "income" 600.00 "Freelance" "SEO optimization gig" "2025-06-18"
create_transaction "income" 950.00 "Freelance" "API integration project" "2025-08-12"
create_transaction "income" 1500.00 "Freelance" "Full-stack dashboard build" "2025-10-03"
create_transaction "income" 700.00 "Freelance" "WordPress plugin development" "2025-12-08"
create_transaction "income" 1100.00 "Freelance" "React Native app feature" "2026-01-20"

# --- Investments ---
log_info "Adding Investment income..."
create_transaction "income" 150.00 "Investments" "Stock dividends - Q1" "2025-03-15"
create_transaction "income" 200.00 "Investments" "Crypto trading profit" "2025-04-20"
create_transaction "income" 180.00 "Investments" "Stock dividends - Q2" "2025-06-15"
create_transaction "income" 320.00 "Investments" "Bond interest payment" "2025-07-01"
create_transaction "income" 175.00 "Investments" "Stock dividends - Q3" "2025-09-15"
create_transaction "income" 250.00 "Investments" "Mutual fund returns" "2025-11-10"
create_transaction "income" 190.00 "Investments" "Stock dividends - Q4" "2025-12-15"
create_transaction "income" 400.00 "Investments" "Crypto staking rewards" "2026-01-05"

# --- Gifts ---
log_info "Adding Gift income..."
create_transaction "income" 500.00 "Gifts" "Birthday cash gift from family" "2025-04-10"
create_transaction "income" 200.00 "Gifts" "Holiday bonus from uncle" "2025-12-25"
create_transaction "income" 100.00 "Gifts" "Cash gift from friend" "2025-08-15"

# --- Side Business ---
log_info "Adding Side Business income..."
create_transaction "income" 350.00 "Side Business" "Online course sales - Jan" "2025-01-20"
create_transaction "income" 420.00 "Side Business" "Online course sales - Mar" "2025-03-20"
create_transaction "income" 380.00 "Side Business" "Online course sales - May" "2025-05-20"
create_transaction "income" 500.00 "Side Business" "Online course sales - Jul" "2025-07-20"
create_transaction "income" 460.00 "Side Business" "Online course sales - Sep" "2025-09-20"
create_transaction "income" 550.00 "Side Business" "Online course sales - Nov" "2025-11-20"
create_transaction "income" 600.00 "Side Business" "Online course sales - Jan 2026" "2026-01-20"

# --- Refunds ---
log_info "Adding Refund income..."
create_transaction "income" 85.00 "Refunds" "Amazon order refund" "2025-02-05"
create_transaction "income" 45.00 "Refunds" "Subscription cancellation refund" "2025-05-12"
create_transaction "income" 120.00 "Refunds" "Flight cancellation refund" "2025-09-08"

# ----------------------------------------------------------
# 5. Populate EXPENSE transactions
# ----------------------------------------------------------
log_section "Creating EXPENSE Transactions"

# --- Food & Dining ---
log_info "Adding Food & Dining expenses..."
create_transaction "expense" 45.50 "Food" "Weekly groceries" "2025-01-05"
create_transaction "expense" 32.00 "Food" "Dinner at restaurant" "2025-01-12"
create_transaction "expense" 55.80 "Food" "Weekly groceries" "2025-01-19"
create_transaction "expense" 18.50 "Food" "Lunch with colleagues" "2025-01-25"
create_transaction "expense" 62.30 "Food" "Weekly groceries" "2025-02-02"
create_transaction "expense" 28.00 "Food" "Coffee shop visits" "2025-02-14"
create_transaction "expense" 48.90 "Food" "Weekly groceries" "2025-02-22"
create_transaction "expense" 75.00 "Food" "Birthday dinner out" "2025-03-08"
create_transaction "expense" 52.40 "Food" "Weekly groceries" "2025-03-15"
create_transaction "expense" 15.00 "Food" "Street food" "2025-03-28"
create_transaction "expense" 44.60 "Food" "Weekly groceries" "2025-04-06"
create_transaction "expense" 38.00 "Food" "Takeout Chinese food" "2025-04-18"
create_transaction "expense" 58.20 "Food" "Weekly groceries" "2025-05-04"
create_transaction "expense" 22.50 "Food" "Fast food lunch" "2025-05-16"
create_transaction "expense" 50.10 "Food" "Weekly groceries" "2025-06-01"
create_transaction "expense" 85.00 "Food" "Dinner party supplies" "2025-06-20"
create_transaction "expense" 47.30 "Food" "Weekly groceries" "2025-07-06"
create_transaction "expense" 35.00 "Food" "Pizza night" "2025-07-19"
create_transaction "expense" 60.50 "Food" "Weekly groceries" "2025-08-03"
create_transaction "expense" 42.00 "Food" "Sushi restaurant" "2025-08-22"
create_transaction "expense" 53.80 "Food" "Weekly groceries" "2025-09-07"
create_transaction "expense" 29.50 "Food" "Coffee and snacks" "2025-09-20"
create_transaction "expense" 49.00 "Food" "Weekly groceries" "2025-10-05"
create_transaction "expense" 65.00 "Food" "Thanksgiving groceries" "2025-11-22"
create_transaction "expense" 72.00 "Food" "Christmas dinner supplies" "2025-12-20"
create_transaction "expense" 55.00 "Food" "Weekly groceries" "2026-01-10"
create_transaction "expense" 40.00 "Food" "Lunch with friends" "2026-02-01"

# --- Transport ---
log_info "Adding Transport expenses..."
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-01-02"
create_transaction "expense" 35.00 "Transport" "Uber rides" "2025-01-18"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-02-01"
create_transaction "expense" 45.00 "Transport" "Fuel for car" "2025-02-20"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-03-01"
create_transaction "expense" 120.00 "Transport" "Car maintenance" "2025-03-15"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-04-01"
create_transaction "expense" 40.00 "Transport" "Uber rides" "2025-05-10"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-05-01"
create_transaction "expense" 55.00 "Transport" "Fuel for car" "2025-06-12"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-06-01"
create_transaction "expense" 250.00 "Transport" "Tire replacement" "2025-07-08"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-08-01"
create_transaction "expense" 38.00 "Transport" "Uber rides" "2025-09-05"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-10-01"
create_transaction "expense" 60.00 "Transport" "Fuel for car" "2025-11-14"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2025-12-01"
create_transaction "expense" 50.00 "Transport" "Monthly bus pass" "2026-01-01"
create_transaction "expense" 42.00 "Transport" "Bolt rides" "2026-02-05"

# --- Utilities ---
log_info "Adding Utilities expenses..."
create_transaction "expense" 85.00 "Utilities" "Electricity bill - Jan" "2025-01-10"
create_transaction "expense" 45.00 "Utilities" "Water bill - Jan" "2025-01-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Jan" "2025-01-10"
create_transaction "expense" 78.00 "Utilities" "Electricity bill - Feb" "2025-02-10"
create_transaction "expense" 45.00 "Utilities" "Water bill - Feb" "2025-02-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Feb" "2025-02-10"
create_transaction "expense" 92.00 "Utilities" "Electricity bill - Mar" "2025-03-10"
create_transaction "expense" 48.00 "Utilities" "Water bill - Mar" "2025-03-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Mar" "2025-03-10"
create_transaction "expense" 70.00 "Utilities" "Electricity bill - Apr" "2025-04-10"
create_transaction "expense" 42.00 "Utilities" "Water bill - Apr" "2025-04-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Apr" "2025-04-10"
create_transaction "expense" 65.00 "Utilities" "Electricity bill - May" "2025-05-10"
create_transaction "expense" 40.00 "Utilities" "Water bill - May" "2025-05-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - May" "2025-05-10"
create_transaction "expense" 88.00 "Utilities" "Electricity bill - Jun" "2025-06-10"
create_transaction "expense" 50.00 "Utilities" "Water bill - Jun" "2025-06-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Jun" "2025-06-10"
create_transaction "expense" 95.00 "Utilities" "Electricity bill - Jul" "2025-07-10"
create_transaction "expense" 52.00 "Utilities" "Water bill - Jul" "2025-07-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Jul" "2025-07-10"
create_transaction "expense" 82.00 "Utilities" "Electricity bill - Aug" "2025-08-10"
create_transaction "expense" 44.00 "Utilities" "Water bill - Aug" "2025-08-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Aug" "2025-08-10"
create_transaction "expense" 75.00 "Utilities" "Electricity bill - Sep" "2025-09-10"
create_transaction "expense" 43.00 "Utilities" "Water bill - Sep" "2025-09-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Sep" "2025-09-10"
create_transaction "expense" 80.00 "Utilities" "Electricity bill - Oct" "2025-10-10"
create_transaction "expense" 46.00 "Utilities" "Water bill - Oct" "2025-10-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Oct" "2025-10-10"
create_transaction "expense" 90.00 "Utilities" "Electricity bill - Nov" "2025-11-10"
create_transaction "expense" 47.00 "Utilities" "Water bill - Nov" "2025-11-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Nov" "2025-11-10"
create_transaction "expense" 98.00 "Utilities" "Electricity bill - Dec" "2025-12-10"
create_transaction "expense" 50.00 "Utilities" "Water bill - Dec" "2025-12-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Dec" "2025-12-10"
create_transaction "expense" 85.00 "Utilities" "Electricity bill - Jan 2026" "2026-01-10"
create_transaction "expense" 45.00 "Utilities" "Water bill - Jan 2026" "2026-01-10"
create_transaction "expense" 60.00 "Utilities" "Internet bill - Jan 2026" "2026-01-10"

# --- Entertainment ---
log_info "Adding Entertainment expenses..."
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-01-05"
create_transaction "expense" 9.99 "Entertainment" "Spotify subscription" "2025-01-05"
create_transaction "expense" 45.00 "Entertainment" "Movie tickets for two" "2025-01-20"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-02-05"
create_transaction "expense" 30.00 "Entertainment" "Board game purchase" "2025-02-15"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-03-05"
create_transaction "expense" 60.00 "Entertainment" "Concert tickets" "2025-03-25"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-04-05"
create_transaction "expense" 25.00 "Entertainment" "Bowling night" "2025-04-22"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-05-05"
create_transaction "expense" 80.00 "Entertainment" "Amusement park entry" "2025-06-15"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-06-05"
create_transaction "expense" 35.00 "Entertainment" "Museum and gallery visit" "2025-07-12"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-07-05"
create_transaction "expense" 120.00 "Entertainment" "Festival weekend pass" "2025-08-20"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-08-05"
create_transaction "expense" 50.00 "Entertainment" "Escape room with friends" "2025-09-14"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-10-05"
create_transaction "expense" 40.00 "Entertainment" "Halloween party supplies" "2025-10-28"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-11-05"
create_transaction "expense" 70.00 "Entertainment" "Christmas party" "2025-12-18"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2025-12-05"
create_transaction "expense" 15.99 "Entertainment" "Netflix subscription" "2026-01-05"
create_transaction "expense" 55.00 "Entertainment" "New Year celebration" "2026-01-01"

# --- Healthcare ---
log_info "Adding Healthcare expenses..."
create_transaction "expense" 150.00 "Healthcare" "Doctor visit - annual checkup" "2025-01-22"
create_transaction "expense" 45.00 "Healthcare" "Pharmacy - cold medicine" "2025-02-18"
create_transaction "expense" 200.00 "Healthcare" "Dental cleaning" "2025-03-20"
create_transaction "expense" 35.00 "Healthcare" "Pharmacy - vitamins" "2025-04-05"
create_transaction "expense" 80.00 "Healthcare" "Eye exam" "2025-05-22"
create_transaction "expense" 250.00 "Healthcare" "New prescription glasses" "2025-05-25"
create_transaction "expense" 60.00 "Healthcare" "Physiotherapy session" "2025-07-14"
create_transaction "expense" 60.00 "Healthcare" "Physiotherapy session" "2025-07-28"
create_transaction "expense" 40.00 "Healthcare" "Pharmacy - allergy meds" "2025-08-10"
create_transaction "expense" 120.00 "Healthcare" "Blood test panel" "2025-09-18"
create_transaction "expense" 200.00 "Healthcare" "Dental filling" "2025-11-05"
create_transaction "expense" 55.00 "Healthcare" "Flu shot and checkup" "2025-12-02"
create_transaction "expense" 30.00 "Healthcare" "Pharmacy - pain relief" "2026-01-15"

# --- Education ---
log_info "Adding Education expenses..."
create_transaction "expense" 199.00 "Education" "Udemy course bundle" "2025-01-08"
create_transaction "expense" 49.00 "Education" "Programming book" "2025-02-12"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-03-01"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-04-01"
create_transaction "expense" 150.00 "Education" "AWS certification exam" "2025-04-15"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-05-01"
create_transaction "expense" 35.00 "Education" "Technical conference ticket" "2025-06-10"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-06-01"
create_transaction "expense" 89.00 "Education" "Design workshop" "2025-07-25"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-08-01"
create_transaction "expense" 45.00 "Education" "JavaScript reference book" "2025-09-05"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-10-01"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-11-01"
create_transaction "expense" 250.00 "Education" "Docker & K8s bootcamp" "2025-11-15"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2025-12-01"
create_transaction "expense" 29.99 "Education" "Pluralsight monthly sub" "2026-01-01"

# --- Shopping ---
log_info "Adding Shopping expenses..."
create_transaction "expense" 120.00 "Shopping" "New running shoes" "2025-01-15"
create_transaction "expense" 85.00 "Shopping" "Winter jacket" "2025-01-28"
create_transaction "expense" 45.00 "Shopping" "Valentine's Day gift" "2025-02-14"
create_transaction "expense" 200.00 "Shopping" "New headphones" "2025-03-10"
create_transaction "expense" 60.00 "Shopping" "Spring wardrobe refresh" "2025-04-12"
create_transaction "expense" 150.00 "Shopping" "Backpack for travel" "2025-05-20"
create_transaction "expense" 95.00 "Shopping" "Sunglasses" "2025-06-08"
create_transaction "expense" 180.00 "Shopping" "Summer clothes haul" "2025-07-15"
create_transaction "expense" 70.00 "Shopping" "Kitchen gadgets" "2025-08-05"
create_transaction "expense" 300.00 "Shopping" "Mechanical keyboard" "2025-09-12"
create_transaction "expense" 250.00 "Shopping" "Black Friday deals" "2025-11-28"
create_transaction "expense" 400.00 "Shopping" "Christmas gifts for family" "2025-12-15"
create_transaction "expense" 55.00 "Shopping" "New water bottle and accessories" "2026-01-08"
create_transaction "expense" 130.00 "Shopping" "New dress shirt and tie" "2026-02-10"

# --- Rent ---
log_info "Adding Rent expenses..."
create_transaction "expense" 950.00 "Rent" "Monthly rent - January" "2025-01-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - February" "2025-02-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - March" "2025-03-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - April" "2025-04-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - May" "2025-05-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - June" "2025-06-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - July" "2025-07-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - August" "2025-08-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - September" "2025-09-01"
create_transaction "expense" 950.00 "Rent" "Monthly rent - October" "2025-10-01"
create_transaction "expense" 1000.00 "Rent" "Monthly rent - November (increase)" "2025-11-01"
create_transaction "expense" 1000.00 "Rent" "Monthly rent - December" "2025-12-01"
create_transaction "expense" 1000.00 "Rent" "Monthly rent - January 2026" "2026-01-01"
create_transaction "expense" 1000.00 "Rent" "Monthly rent - February 2026" "2026-02-01"

# --- Insurance ---
log_info "Adding Insurance expenses..."
create_transaction "expense" 120.00 "Insurance" "Health insurance - Q1" "2025-01-05"
create_transaction "expense" 120.00 "Insurance" "Health insurance - Q2" "2025-04-05"
create_transaction "expense" 120.00 "Insurance" "Health insurance - Q3" "2025-07-05"
create_transaction "expense" 120.00 "Insurance" "Health insurance - Q4" "2025-10-05"
create_transaction "expense" 85.00 "Insurance" "Car insurance - biannual" "2025-01-15"
create_transaction "expense" 85.00 "Insurance" "Car insurance - biannual" "2025-07-15"
create_transaction "expense" 120.00 "Insurance" "Health insurance - Q1 2026" "2026-01-05"

# --- Fitness ---
log_info "Adding Fitness expenses..."
create_transaction "expense" 40.00 "Fitness" "Gym membership - Jan" "2025-01-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Feb" "2025-02-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Mar" "2025-03-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Apr" "2025-04-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - May" "2025-05-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Jun" "2025-06-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Jul" "2025-07-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Aug" "2025-08-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Sep" "2025-09-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Oct" "2025-10-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Nov" "2025-11-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Dec" "2025-12-03"
create_transaction "expense" 40.00 "Fitness" "Gym membership - Jan 2026" "2026-01-03"
create_transaction "expense" 75.00 "Fitness" "New yoga mat and weights" "2025-03-18"
create_transaction "expense" 50.00 "Fitness" "Running shoes insoles" "2025-08-22"

# --- Travel ---
log_info "Adding Travel expenses..."
create_transaction "expense" 350.00 "Travel" "Weekend trip to Cape Coast" "2025-02-22"
create_transaction "expense" 200.00 "Travel" "Hotel stay - Cape Coast" "2025-02-23"
create_transaction "expense" 500.00 "Travel" "Flight to Tamale" "2025-05-15"
create_transaction "expense" 180.00 "Travel" "Hotel stay - Tamale" "2025-05-16"
create_transaction "expense" 150.00 "Travel" "Local tours and activities" "2025-05-17"
create_transaction "expense" 800.00 "Travel" "Summer vacation flight" "2025-07-20"
create_transaction "expense" 450.00 "Travel" "Vacation hotel - 3 nights" "2025-07-21"
create_transaction "expense" 200.00 "Travel" "Vacation dining and activities" "2025-07-22"
create_transaction "expense" 280.00 "Travel" "Long weekend getaway" "2025-10-10"
create_transaction "expense" 600.00 "Travel" "Christmas trip flight" "2025-12-22"
create_transaction "expense" 350.00 "Travel" "Christmas trip hotel" "2025-12-23"

# --- Miscellaneous ---
log_info "Adding Miscellaneous expenses..."
create_transaction "expense" 25.00 "Miscellaneous" "Haircut" "2025-01-10"
create_transaction "expense" 15.00 "Miscellaneous" "Dry cleaning" "2025-02-08"
create_transaction "expense" 30.00 "Miscellaneous" "Pet supplies" "2025-03-12"
create_transaction "expense" 25.00 "Miscellaneous" "Haircut" "2025-04-10"
create_transaction "expense" 50.00 "Miscellaneous" "Home cleaning supplies" "2025-05-08"
create_transaction "expense" 25.00 "Miscellaneous" "Haircut" "2025-07-10"
create_transaction "expense" 35.00 "Miscellaneous" "Charity donation" "2025-08-15"
create_transaction "expense" 25.00 "Miscellaneous" "Haircut" "2025-10-10"
create_transaction "expense" 100.00 "Miscellaneous" "Phone screen repair" "2025-11-20"
create_transaction "expense" 25.00 "Miscellaneous" "Haircut" "2026-01-10"

# ----------------------------------------------------------
# 6. Test READ operations - List & Filter
# ----------------------------------------------------------
log_section "Testing LIST Transactions (GET /api/transactions)"

log_info "Fetching all transactions..."
ALL_TXN=$(curl -s "$BASE_URL/api/transactions" -H "$AUTH_HEADER")
TOTAL=$(echo "$ALL_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Total transactions created: $TOTAL"

log_info "Filtering by type=income..."
INCOME_TXN=$(curl -s "$BASE_URL/api/transactions?type=income" -H "$AUTH_HEADER")
INCOME_COUNT=$(echo "$INCOME_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Income transactions: $INCOME_COUNT"

log_info "Filtering by type=expense..."
EXPENSE_TXN=$(curl -s "$BASE_URL/api/transactions?type=expense" -H "$AUTH_HEADER")
EXPENSE_COUNT=$(echo "$EXPENSE_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Expense transactions: $EXPENSE_COUNT"

log_info "Filtering by category=Food..."
FOOD_TXN=$(curl -s "$BASE_URL/api/transactions?category=Food" -H "$AUTH_HEADER")
FOOD_COUNT=$(echo "$FOOD_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Food transactions: $FOOD_COUNT"

log_info "Filtering by category=Salary..."
SALARY_TXN=$(curl -s "$BASE_URL/api/transactions?category=Salary" -H "$AUTH_HEADER")
SALARY_COUNT=$(echo "$SALARY_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Salary transactions: $SALARY_COUNT"

log_info "Filtering by date range (Q1 2025)..."
Q1_TXN=$(curl -s "$BASE_URL/api/transactions?from=2025-01-01&to=2025-03-31" -H "$AUTH_HEADER")
Q1_COUNT=$(echo "$Q1_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Q1 2025 transactions: $Q1_COUNT"

log_info "Filtering by type=expense & category=Rent..."
RENT_TXN=$(curl -s "$BASE_URL/api/transactions?type=expense&category=Rent" -H "$AUTH_HEADER")
RENT_COUNT=$(echo "$RENT_TXN" | python3 -c "import sys,json; data=json.load(sys.stdin); print(len(data))" 2>/dev/null)
log_success "Rent expense transactions: $RENT_COUNT"

# ----------------------------------------------------------
# 7. Test SUMMARY endpoint
# ----------------------------------------------------------
log_section "Testing SUMMARY (GET /api/transactions/summary)"

log_info "Full summary (all time)..."
SUMMARY=$(curl -s "$BASE_URL/api/transactions/summary" -H "$AUTH_HEADER")
echo "$SUMMARY" | python3 -m json.tool 2>/dev/null || echo "$SUMMARY"
log_success "Full summary retrieved"

log_info "Summary for Q1 2025..."
Q1_SUMMARY=$(curl -s "$BASE_URL/api/transactions/summary?from=2025-01-01&to=2025-03-31" -H "$AUTH_HEADER")
echo "$Q1_SUMMARY" | python3 -m json.tool 2>/dev/null || echo "$Q1_SUMMARY"
log_success "Q1 2025 summary retrieved"

log_info "Summary for 2026 so far..."
SUMMARY_2026=$(curl -s "$BASE_URL/api/transactions/summary?from=2026-01-01&to=2026-02-15" -H "$AUTH_HEADER")
echo "$SUMMARY_2026" | python3 -m json.tool 2>/dev/null || echo "$SUMMARY_2026"
log_success "2026 YTD summary retrieved"

# ----------------------------------------------------------
# 8. Final Report
# ----------------------------------------------------------
log_section "FINAL REPORT"
echo ""
echo -e "  Account Email:     ${CYAN}$USER_EMAIL${NC}"
echo -e "  Account Password:  ${CYAN}$USER_PASSWORD${NC}"
echo -e "  Successes:         ${GREEN}$success_count${NC}"
echo -e "  Failures:          ${RED}$fail_count${NC}"
echo ""
echo -e "${YELLOW}Categories populated:${NC}"
echo "  INCOME:  Salary, Freelance, Investments, Gifts, Side Business, Refunds"
echo "  EXPENSE: Food, Transport, Utilities, Entertainment, Healthcare,"
echo "           Education, Shopping, Rent, Insurance, Fitness, Travel, Miscellaneous"
echo ""
echo -e "${YELLOW}Date range:${NC} January 2025 — February 2026 (14 months)"
echo ""
log_info "Script complete!"
