# Use the official Moodle HQ PHP + Apache base image
FROM moodlehq/moodle-php-apache:8.3

# Install PostgreSQL client tools and networking utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Create dataroot directory outside the web root
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 775 /var/www/moodledata

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy local Moodle source code into the web root
WORKDIR /var/www/html
COPY . /var/www/html/

# Ensure Apache has ownership of the files
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]