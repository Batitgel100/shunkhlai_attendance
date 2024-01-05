class Globals {
  static late String gmail;

  static late int id;
  static bool isLogin = false;
  static bool isStockUser = false;
  static bool isStockAdmin = false;
  static int employeeId = 0;
  static int departmentId = 0;
  static late String phone;
  static int regid = 0;
  static late String baseUrl;
  static late String register;
  static String binary = '';
  static late String refreshToken;
  static late String address;
  static late String password;
  static String company = '';
  static int companyId = 0;
  static late int userId;
  static int timer = 0;
  static double lat = 0.0;
  static double long = 0.0;
  static String userName = '';

  static void changeGmail(String a) {
    gmail = a;
  }

  static String getGmail() {
    return gmail;
  }

  static void changeUserName(String a) {
    userName = a;
  }

  static String getUserName() {
    return userName;
  }

  static void changeBinary(String a) {
    binary = a;
  }

  static String getBinary() {
    return binary;
  }

  static void changeCompany(String a) {
    company = a;
  }

  static String getCompany() {
    return company;
  }

  static void changeUserId(int a) {
    userId = a;
  }

  static int getUserId() {
    return userId;
  }

  static void changeDepartmentId(int a) {
    departmentId = a;
  }

  static int getDepartmentId() {
    return departmentId;
  }

  static void changeStockId(int a) {
    userId = a;
  }

  static int getStockId() {
    return userId;
  }

  static void changeCompanyId(int a) {
    companyId = a;
  }

  static int getCompanyId() {
    return companyId;
  }

  static void changeTimer(int a) {
    timer = a;
  }

  static int getTimer() {
    return timer;
  }

  static void changeEmployeeId(int a) {
    employeeId = a;
  }

  static int getEmployeeId() {
    return employeeId;
  }

  static void changelat(double a) {
    lat = a;
  }

  static double getlat() {
    return lat;
  }

  static void changelong(double a) {
    long = a;
  }

  static double getlong() {
    return long;
  }

  static void changeregid(int a) {
    regid = a;
  }

  static int getregid() {
    return regid;
  }

  static void changeRegister(String a) {
    register = a;
  }

  static String getRegister() {
    return register;
  }

  static void changeRefreshToken(String a) {
    refreshToken = a;
  }

  static String getRefreshToken() {
    return refreshToken;
  }

  static void changeAddress(String a) {
    address = a;
  }

  static String getAddress() {
    return address;
  }

  static void changePassword(String a) {
    password = a;
  }

  static String getPassword() {
    return password;
  }

  static void changeUserPhone(String a) {
    phone = a;
  }

  static String getUserPhone() {
    return phone;
  }

  static void changebaseUrl(String a) {
    baseUrl = a;
  }

  static String getbaseUrl() {
    return baseUrl;
  }

  static void changeIsLogin(bool a) {
    isLogin = a;
  }

  static bool getIsLogin() {
    return isLogin;
  }

  static void changeIsStockUser(bool a) {
    isStockUser = a;
  }

  static bool getIsStockUser() {
    return isStockUser;
  }

  static void changeIsStockAdmin(bool a) {
    isStockAdmin = a;
  }

  static bool getIsStockAdmin() {
    return isStockAdmin;
  }
}
