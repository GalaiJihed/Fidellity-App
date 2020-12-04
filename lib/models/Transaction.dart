class Transaction {
  String image;
  String name;
  String date;
  double amount;

  Transaction({this.image, this.name, this.date, this.amount});

  static List<Transaction> getTransactions() {
    return [
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=1GiWdgZjgCu41sJM7okEXgr7j5gC1BpDl",
          name: "Sofa",
          date: "2020-06-12 12:29",
          amount: 1000.50),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=1_VRbb2IGhC05n6T6jPQBmU8-APXinf7p",
          name: "Twin Bed",
          date: "2020-06-12 12:25",
          amount: 2080.50),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=1H-2UrY3HCflOebkSwnnTM8aMr8Bs39jB",
          name: "Donut",
          date: "2020-06-12 08:30",
          amount: 2.5),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=1bNVPTnVyHzjB1KSd0zpc3DXtupS9KiC4",
          name: "Croissant",
          date: "2020-06-12 09:04",
          amount: 1.50),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=173k4Jr5NaEeJ6perYnfXtKSCZ58aKX0l",
          name: "Coffee",
          date: "2020-06-12 09:08",
          amount: 1.5),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=1HlFylg9l2sqWp3iTzX_7QnlYS3WSa_bM",
          name: "Air Conditionner",
          date: "2020-06-12 12:30",
          amount: 1080.0),
      new Transaction(
          image:
          "https://drive.google.com/uc?export=view&id=12eEPmXNDkbXauNRTbrnmoZcRMfEIOKPJ",
          name: "Pizza",
          date: "2020-06-12 12:29",
          amount: 6.50),
    ];
  }
}