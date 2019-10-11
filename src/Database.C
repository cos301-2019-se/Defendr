#include "Database.h"

Database::Database ()
{
    mongoc_init ();
	client = mongoc_client_new (uri_str);
	mongoc_client_set_appname (client, "defendr-logging");
	database = mongoc_client_get_database (client, "Defendr");
}

Database::~Database ()
{
	mongoc_client_destroy (client);
	mongoc_cleanup ();
}

void Database::insert_into_packets_list (const char* ip_source, const char* status, const char* timestamp, const char* country_id, const char* ip_destination, const char* server, const char* reason)
{
    collection = mongoc_client_get_collection (client, "Defendr", "packets_list");
	bson_t *bson;
	char *string;
	char* json;
	asprintf(&json,"{\"ip_source\":\"%s\",\"status\":\"%s\",\"timestamp\":\"%s\",\"country_id\":\"%s\",\"ip_destination\":\"%s\",\"server\":\"%s\",\"reason\":\"%s\"}", ip_source, status, timestamp, country_id, ip_destination, server, reason);
	//printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);

	return;
}

void Database::insert_into_blacklist (const char *ip)
{
collection = mongoc_client_get_collection (client, "Defendr", "blacklist");
bson_t *bson;
	char *string;
	char* json;
	asprintf(&json,"{\"ip\":\"%s\"}", ip);
	//printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);

	return;
}

void Database::insert_into_whitelist (const char *ip)
{
	collection = mongoc_client_get_collection (client, "Defendr", "whitelist");
	bson_t *bson;
	char *string;
	char* json;
	asprintf(&json,"{\"ip\":\"%s\"}", ip);
	//printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);

	return;
}

void Database::insert_into_country (const char *country_id, const char *country_name, const char *status)
{
	collection = mongoc_client_get_collection (client, "Defendr", "country");
	bson_t *bson;
	char *string;
	char* json;
	asprintf(&json,"{\"country_id\":\"%s\",\"country_name\":\"%s\",\"status\":\"%s\"}", country_id, country_name, status);
	//printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);

	return;
}
