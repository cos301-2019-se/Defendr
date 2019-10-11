#ifndef DATABASE_H
#define DATABASE_H

#include <string.h>
#include <time.h>
#include <mongoc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


class Database
{
    public:
        static Database& getInstance ()
        {
            static Database instance;
            return instance;
        }
        void insert_into_packets_list (const char* , const char* , const char* , const char* , const char* , const char*, const char*);
        void insert_into_blacklist (const char*);
        void insert_into_whitelist (const char*);
        void insert_into_country (const char*, const char*, const char*);

    protected:
        Database ();
        ~Database ();

    private:
        const char *uri_str = "mongodb+srv://darknites:D%40rkN1t3s@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true&ssl=true";
   	mongoc_client_t *client;
   	mongoc_database_t *database;
   	mongoc_collection_t *collection;
   	bson_t *command, reply, *insert;
   	bson_error_t error;
   	char *str;
   	bool retval;
};

#endif