class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String address;
  int phoneNumber;
  int countryCode;
  String country;
  DateTime birthDate;
  int postalCode;
  String password;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  String role;
  String city;
  String image;
  int fidelityPoints;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.phoneNumber,
      this.countryCode,
      this.country,
      this.postalCode,
      this.city,
      this.fidelityPoints,
      this.image});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'country': country,
      'postalCode': postalCode,
      'city': city,
      'fidelityPoints': fidelityPoints,
      'birthDate': birthDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'image': image
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    address = map['address'];
    phoneNumber = map['phoneNumber'] as int;
    countryCode = map['countryCode'] as int;
    country = map['country'];
    postalCode = map['postalCode'] as int;
    city = map['city'];
    fidelityPoints = map['fidelityPoints'] as int;
    image = map['image'];
    updatedAt = fromTimestampToDateTime(map['updatedAt']);
    birthDate = fromTimestampToDateTime(map['birthDate']);
    createdAt = fromTimestampToDateTime(map['createdAt']);
  }

  DateTime fromTimestampToDateTime(int date) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "User {id : " +
        id.toString() +
        "\n firstName : " +
        firstName.toString() +
        "\n lastName : " +
        lastName.toString() +
        "\n address : " +
        address.toString() +
        "\n email : " +
        email.toString() +
        "\n image : " +
        image.toString() +
        "\n phoneNumber : " +
        phoneNumber.toString() +
        "\n countryCode : " +
        countryCode.toString() +
        "\n country : " +
        country.toString() +
        "\n city : " +
        city.toString() +
        "\n fidelityPoints : " +
        fidelityPoints.toString() +
        "\n birthDate : " +
        birthDate.toString() +
        "\n createdAt : " +
        createdAt.toString() +
        "\n updatedAt : " +
        updatedAt.toString() +
        "}";
  }
}
