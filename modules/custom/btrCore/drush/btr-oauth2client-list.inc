<?php
/**
 * Description of the command 'btr-oauth2client-list'.
 */
function _btr_oauth2client_list_drush_command() {
  return array(
    'description' => "List registered oauth2 clients.",
    'arguments' => array(),
    'options' => array(),
    'examples' => array(
      "drush btr-client-ls" => '',
    ),
    'aliases' => array('btr-client-ls'),
  );
}

/**
 * Help text for the command 'btr-oauth2client-list'.
 */
function _btr_oauth2client_list_drush_help() {
  return dt("List registered oauth2 clients.");
}

/**
 * Callback function for the command 'btr-oauth2client-list'.
 */
function drush_btranslator_btr_oauth2client_list() {
  $clients = btr::oauth2_client_list();
  print "client_key,redirect_uri\n";
  foreach ($clients as $client) {
    print "$client->client_key,$client->redirect_uri\n";
  }
}
