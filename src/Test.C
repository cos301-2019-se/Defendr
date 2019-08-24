#include "Database.h"
#include <iostream>
using namespace std;

int main(){
    vector<char*> v = Database::getInstance().mailing_list();
    for(int i = 0; i < v.size(); i++)
        printf("%s\n", v[i]);
    return 0;
}