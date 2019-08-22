#include "Database.h"

using namespace std;

int main(){
    Database* database = Database.getInstance()
    database->mailing_list();
    //database->remove_from_blacklist('');
    //database->remove_from_whitelist('')
    return 0;
}