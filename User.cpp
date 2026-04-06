#include "User.h"
#include <fstream>
#include <sstream>

const string USERS_FILE = "users.txt";
// User::User(const string& uname, const string& pwd) : username(uname), password(pwd), balance(0.0) {}

string User::GetUsername() const { return username; }
string User::GetPassword() const { return password; }
double User::GetBalance()  const { return balance; }

bool User::deposit(double amount, string date)
{
    if (amount > 0)
    {
        balance += amount;
        transactionHistory.push_back({"Deposit", amount, date});
        return true;
    }
    return false;
}

bool User::withdraw(double amount, string date)
{
    if (amount > 0 && amount <= balance)
    {
        balance -= amount;
        transactionHistory.push_back({"Withdrawal", amount, date});
        return true;
    }
    return false;
}
bool User::transfer(User& recipient, double amount, string date)
{
    if (amount > 0 && amount <= balance)
    {
        balance -= amount;
        recipient.balance += amount;

        transactionHistory.push_back({"Send", amount, date});
        recipient.transactionHistory.push_back({"Receive", amount, date});
        return true;
    }
    return false;
}
void User::DisplayHistory() const
{
    cout << "Transaction History for " << username << ":\n";
    for (const auto& t : transactionHistory) {
        cout << t.date << " - " << t.type << ": $" << t.amount << endl;
    }
    cout << "===========================" << endl;
}
void User::saveToFile() const
{
    vector<string> otherLines;
    ifstream inFile(USERS_FILE);

    if (inFile.is_open())
    {
        string line;
        bool skip = false;

        while (getline(inFile, line))
        {
            if (line.find(username + ",") == 0)
            {
                skip = true; // start skipping this user's block
            }
            if (!skip)
            {
                otherLines.push_back(line);
            }
            if (skip && line == "END")
            {
                skip = false; // done skipping
            }
        }
        inFile.close();
    }

    ofstream outFile(USERS_FILE);
    for (const string& l : otherLines)
    {
        outFile << l << "\n";
    }

    outFile << username << "," << password << "," << GetBalance() << "\n";

    for (const Transaction& t : transactionHistory)
    {
        outFile << "TRANSACTION," << t.type << "," << t.amount << "," << t.date << "\n";
    }

    outFile << "END\n";

    outFile.close();
    cout << "User saved successfully." << endl;
}

User User::loadFromFile(const string& targetUsername)
{
    ifstream inFile(USERS_FILE);
    if (!inFile.is_open())
    {
        ofstream createFile(USERS_FILE);
        createFile.close();
        return User();
    }

    string line;
    User loadedUser;

    while (getline(inFile, line))
    {
        if (line.find(targetUsername + ",") == 0)
        {
            stringstream ss(line);
            string uname, pwd, balStr;
            getline(ss, uname,  ',');
            getline(ss, pwd,    ',');
            getline(ss, balStr, ',');

            loadedUser = User(uname, pwd);
            loadedUser.balance = stod(balStr);

            while (getline(inFile, line) && line != "END")
            {
                if (line.find("TRANSACTION,") == 0)
                {
                    stringstream tss(line);
                    string prefix, type, amtStr, date;
                    getline(tss, prefix, ',');
                    getline(tss, type,   ',');
                    getline(tss, amtStr, ',');
                    getline(tss, date);
                    loadedUser.transactionHistory.push_back({type, stod(amtStr), date});
                }
            }
            break;
        }
    }

    inFile.close();
    return loadedUser;
}

bool User::userExists(const string& targetUsername)
{
    ifstream inFile(USERS_FILE);
    if (!inFile.is_open())
    {
        ofstream createFile(USERS_FILE);
        createFile.close();
        return false;
    }

    string line;
    bool exists = false;

    while (getline(inFile, line))
    {
        if (line.find(targetUsername + ",") == 0)
        {
            exists = true;
            break;
        }
    }

    inFile.close();
    return exists;
}

User User::registerUser(const string& username, const string& password)
{
    User newUser(username, password);
    newUser.saveToFile();
    return newUser;
}