#include <string.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mongoc.h>

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif

        const char *uri_str = "mongodb+srv://darknites:D%40rkN1t3s@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true&ssl=true";
   	    mongoc_client_t *client;
   	    mongoc_database_t *database;
   	    mongoc_collection_t *collection;
        mongoc_cursor_t *cursor;
   	    bson_t *bson, *query;
   	    bson_error_t error;
   	    char *str;
   	    bool retval;
        const int LOW = 1;
	    const int MED = 0;
	    const int HIGH = -1;

void insert_into_packets_list (const char* ip_source, const char* status, const char* timestamp, const char* country_id, const char* ip_destination, const char* server, const char* reason)
{
	mongoc_init ();
	client = mongoc_client_new (uri_str);
	mongoc_client_set_appname (client, "defendr-logging");
	database = mongoc_client_get_database (client, "Defendr");
    collection = mongoc_client_get_collection (client, "Defendr", "packets_list");
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
	mongoc_client_destroy (client);
	mongoc_cleanup ();
	return;
}

void Database::insert_into_blacklist (const char *ip)
{
	collection = mongoc_client_get_collection (client, "Defendr", "blacklist");
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

int Database::get_status_by_country_name (const char* country_name)
{
	collection = mongoc_client_get_collection (client, "Defendr", "country");
	const bson_t *doc;
	char *str;
	int status = 0;
	
	query = bson_new ();
	BSON_APPEND_UTF8 (query, "country_name", country_name);
	cursor = mongoc_collection_find_with_opts (collection, query, NULL, NULL);
	
	mongoc_cursor_next (cursor, &doc);

	str = bson_as_canonical_extended_json (doc, NULL);
	
	if(strstr(str,"High"))
	{
		status = HIGH;
	}
	else if(strstr(str,"Low"))
	{
		status = LOW;
	}

	bson_free (str);
	bson_destroy (query);
	mongoc_cursor_destroy (cursor);
	mongoc_collection_destroy (collection);
	return status;
}

int Database::get_status_by_country_id(const char* country_id)
{
	collection = mongoc_client_get_collection (client, "Defendr", "country");
	const bson_t *doc;
	char *str;
	int status = 0;
	
	query = bson_new ();
	BSON_APPEND_UTF8 (query, "country_id", country_id);
	cursor = mongoc_collection_find_with_opts (collection, query, NULL, NULL);
	
	mongoc_cursor_next (cursor, &doc);

	if(!doc || !cursor)
	{
		printf("The id %s cannot be found.  Assigning status type HIGH", country_id);
		return HIGH;
	}

	str = bson_as_canonical_extended_json (doc, NULL);
	
	if(strstr(str,"High"))
	{
		status = HIGH;
	}
	else if(strstr(str,"Low"))
	{
		status = LOW;
	}

	bson_free (str);
	bson_destroy (query);
	mongoc_cursor_destroy (cursor);
	mongoc_collection_destroy (collection);
	return status;
}
