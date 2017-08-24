<?php
/**
 * @file
 * Functions for managing oauth2_server_client entities.
 */

namespace BTranslator;

/**
 * Display a list of oauth2 clients.
 */
function oauth2_client_list() {
  $query = new \EntityFieldQuery();
  $query->entityCondition('entity_type', 'oauth2_server_client')
    ->propertyCondition('server', 'oauth2', '=');

  $result = $query->execute();
  $clients = array();
  if (isset($result['oauth2_server_client'])) {
    $client_nids = array_keys($result['oauth2_server_client']);
    $clients = entity_load('oauth2_server_client', $client_nids);
  }
  return $clients;
}

/**
 * Create a new oauth2 client.
 */
function oauth2_client_add($client_key, $client_secret, $redirect_uri) {
  // Delete the given client if already exists.
  oauth2_client_del($client_key);

  // Register a client on the oauth2 server.
  $client = entity_create('oauth2_server_client', array());
  $client->server = 'oauth2';
  $client->label = $client_key;
  $client->client_key = $client_key;
  $client->client_secret = oauth2_server_hash_client_secret($client_secret);
  $client->redirect_uri = $redirect_uri;
  $client->automatic_authorization = TRUE;
  $client->save();
}

/**
 * Delete the given client if exists.
 */
function oauth2_client_del($client_key) {
  $query = new \EntityFieldQuery();
  $query->entityCondition('entity_type', 'oauth2_server_client')
    ->propertyCondition('server', 'oauth2')
    ->propertyCondition('client_key',  $client_key);
  $result = $query->execute();
  if (isset($result['oauth2_server_client'])) {
    $cids = array_keys($result['oauth2_server_client']);
    foreach ($cids as $cid) {
      entity_delete('oauth2_server_client', $cid);
    }
  }
}
