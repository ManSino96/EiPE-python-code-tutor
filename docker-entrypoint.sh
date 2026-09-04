#!/bin/bash
set -e

# Default settings targeting PostgreSQL / Supabase
MOODLE_DB_TYPE=${MOODLE_DB_TYPE:-pgsql}
MOODLE_DB_HOST=${MOODLE_DB_HOST}
MOODLE_DB_PORT=${MOODLE_DB_PORT:-5432}
MOODLE_DB_NAME=${MOODLE_DB_NAME:-postgres}
MOODLE_DB_USER=${MOODLE_DB_USER:-postgres}
MOODLE_DB_PASSWORD=${MOODLE_DB_PASSWORD}
MOODLE_URL=${MOODLE_URL:-http://localhost:8080}
MOODLE_ADMIN_USER=${MOODLE_ADMIN_USER:-admin}
MOODLE_ADMIN_PASS=${MOODLE_ADMIN_PASS:-Admin@12345}
MOODLE_ADMIN_EMAIL=${MOODLE_ADMIN_EMAIL:-admin@example.com}

echo "Waiting for PostgreSQL database connection at ${MOODLE_DB_HOST}:${MOODLE_DB_PORT}..."
until pg_isready -h "$MOODLE_DB_HOST" -p "$MOODLE_DB_PORT" -U "$MOODLE_DB_USER" >/dev/null 2>&1 || \
      nc -z -v -w5 "$MOODLE_DB_HOST" "$MOODLE_DB_PORT" 2>/dev/null; do
  echo "Database is unavailable - sleeping 3 seconds..."
  sleep 3
done
echo "PostgreSQL is reachable!"

# Run automated install if config.php does not exist
if [ ! -f /var/www/html/config.php ]; then
  echo "No config.php detected. Installing Moodle with PostgreSQL driver..."

  php /var/www/html/admin/cli/install.php \
    --lang=en \
    --chmod=2777 \
    --wwwroot="$MOODLE_URL" \
    --dataroot=/var/www/moodledata \
    --dbtype="$MOODLE_DB_TYPE" \
    --dbhost="$MOODLE_DB_HOST" \
    --dbname="$MOODLE_DB_NAME" \
    --dbuser="$MOODLE_DB_USER" \
    --dbpass="$MOODLE_DB_PASSWORD" \
    --dbport="$MOODLE_DB_PORT" \
    --prefix=mdl_ \
    --fullname="local moodle instance" \
    --shortname="moodle" \
    --adminuser="$MOODLE_ADMIN_USER" \
    --adminpass="$MOODLE_ADMIN_PASS" \
    --adminemail="$MOODLE_ADMIN_EMAIL" \
    --agree-license \
    --non-interactive

  chown -R www-data:www-data /var/www/html/config.php /var/www/moodledata
  echo "Moodle installation complete."
fi

exec "$@"