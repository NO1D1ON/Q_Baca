class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({this.title = '', required this.image, this.desc = ''});
}

List<OnboardingContents> contents = [
  // OnboardingContents(image: "assets/pageIcon/slide1.png"),
  OnboardingContents(
    title: "Koleksi Lengkap",
    image: "assets/pageIcon/Slide2.png",
    desc:
        "BukuQu menyediakan berbagai jenis\nbuku dari akademik hingga hiburan,\nsemua ada dalam satu aplikasi.",
  ),
  OnboardingContents(
    title: "Akses Tanpa Batas",
    image: "assets/pageIcon/gambarSlide3.png",
    desc: "Beli buku kapan saja, dimana saja\ntanpa batasan waktu dan tempat.",
  ),
  OnboardingContents(
    title: "Lebih Ramah Alam",
    image: "assets/pageIcon/gambarSlide4.png",
    desc: "Pakai fitur digital buat bantu jaga bumi\ntetap bersih dan sehat.",
  ),
];
