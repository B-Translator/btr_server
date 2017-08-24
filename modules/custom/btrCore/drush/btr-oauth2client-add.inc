<?php
/**
 * Description of the command 'btr-oauth2client-add'.
 */
function _btr_oauth2client_add_drush_command() {
  return array(
    'description' => "Add a new oauth2 client.",
    'arguments' => array(
      'client_key' => '',
      'client_secret' => '',
      'redirect_uri' => '',
    ),
    'options' => array(),
    'examples' => array(),
    'aliases' => array('btr-client-add'),
  );
}

/**
 * Help text for the command 'btr-oauth2client-add'.
 */
function _btr_oauth2client_add_drush_help() {
  return dt("Add a new oauth2 client.");
}

/**
 * Callback function for the command 'btr-oauth2client-add'.
 */
function drush_btranslator_btr_oauth2client_add($client_key, $client_secret, $redirect_uri) {
  btr::oauth2_client_add($client_key, $client_secret, $redirect_uri);
}
