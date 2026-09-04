<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

// Supabase PostgreSQL Configuration
$CFG->dbtype    = 'pgsql';
$CFG->dblibrary = 'native';

// Use your Supabase Pooler host (port 5432) or direct host
$CFG->dbhost    = 'aws-1-eu-west-1.pooler.supabase.com';
$CFG->dbname    = 'postgres';

// Remember to append your project ref if using the Supavisor pooler
$CFG->dbuser    = 'postgres.###';
$CFG->dbpass    = '##';
$CFG->prefix    = 'mdl_';

// SSL enforcement parameters
$CFG->dboptions = array(
    'dbport'        => '5432',
    'dbsocket'      => '',
    'sslmode'       => 'require',     // Required for Supabase
    'sslrootcert' => '/etc/ssl/certs/prod-ca-2021.crt', // In-container path to the mounted cert
    'dbhandlesoptions' => false,
);

// Paths and Web configuration
$CFG->wwwroot   = 'http://localhost:8080';
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');