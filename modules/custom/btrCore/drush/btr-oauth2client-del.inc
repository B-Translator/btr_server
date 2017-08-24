<?php
/**
 * Description of the command 'btr-oauth2client-del'.
 */
function _btr_oauth2client_del_drush_command() {
  return array(
    'description' => "Delete oauth2 client if exists.",
    'arguments' => array(
      'client_key' => 'The key of the client.',
    ),
    'options' => array(),
    'examples' => array(
      "drush btr-client-del client1" => 'Delete client1.',
    ),
    'aliases' => array('btr-client-del'),
  );
}

/**
 * Help text for the command 'btr-oauth2client-del'.
 */
function _btr_oauth2client_del_drush_help() {
  return dt("Delete oauth2 client if exists.");
}

/**
 * Callback function for the command 'btr-oauth2client-del'.
 */
function drush_btranslator_btr_oauth2client_del($client_key) {
  btr::oauth2_client_del($client_key);
}
