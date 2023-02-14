# ATT LONE WORKER APP

## Kullanılan Kütüphaneler


- [Bloc(State Management](https://pub.dev/packages/flutter_bloc)
- [Get It(Dependency Injection)](https://pub.dev/packages/get_it)
- [Dio(Network Transactions)](https://pub.dev/packages/dio)
- [Device Network Connectivity Information](https://pub.dev/packages/connectivity_plus)
- [Logger](https://pub.dev/packages/logger)
- [Log](https://pub.dev/packages/flutter_logs)
- [Background Process](https://pub.dev/packages/workmanager)
- [Flutter EasyLoading](https://pub.dev/packages/flutter_easyloading)
- [Sensor Information](https://pub.dev/packages/sensors_plus)
- [Splash Screen](https://pub.dev/packages/flutter_native_splash)
- [Screen Information](https://pub.dev/packages/flutter_screenutil)
- [Storage](https://pub.dev/packages/hive)
- [Storage](https://pub.dev/packages/hive_flutter)
- [Storage Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Localition](https://pub.dev/packages/geolocator)
- [Lat Long](https://pub.dev/packages/latlong2)
- [Localization](https://pub.dev/packages/easy_localization)
- [Dialog](https://pub.dev/packages/ndialog)
- [Device Information](https://pub.dev/packages/device_info_plus)


## Boilerplate

## Tasarım yaklaşımı

- Kullanılan Widget'ların parçalanması ve gerekli yerlerde tekrar kullanılmasını amaçlayan Atomic Design yaklaşımı referans alınmıştır.
Amaç; Kod Okunabilirliği, Widgeti'ların tekrar tekrar kullanılabilme opsiyonu ve dinamikleştirmek.Atomic Design için örnek döküman;
- [Atomic Design](https://itnext.io/atomic-design-with-flutter-11f6fcb62017)
- Kullanılan Widget'lar UI bazlı veya Uygulama geneli olma durumuna göre View dosyasının altında veya Core Katmanına eklendi

## Kullanılan Mimari

- Katmanlı mimari alt yapısı kullanılarak her katmanın kendi işini yapması amacıyla, kod okunabilirliği açısından ve sonra ki süreçte yapılan uygulamanın değişime direnç göstermemesi amacıyla BLoc Design Pattern kullanılmıştır(Alternatif; Repository Pattern, MVVM)
- Katmanlar; 
  - Model(Model class'ların tutulduğu katmandır.Kullanılan dataların referans modelleri saklanır.)
  - View(UI elemanlarının tutulduğu katmandır ve sadece UI ile ilgili elemanlar tutulmalıdır)
  - Bloc(Business kodunun yazıldığı UI ve Service katmanı arasında ki iş akışını sağlayan katmandır.)
  - Service(Dış Servislere HTTP protokolü üzeriden bağlanılan katmandır.)
  - Core(Uygulama özelinde olmayan ve her hangi bir projede kullanılabilmesi amaçlanan uygulama geneli yapıları tutar,Uygulama bağımsızdır(Örn; Helpers, Constants ve Uygulama dışı kullanılabilecek uygulamaya bağımlı olmayan widgetların tutulduğu katmandır))
  - Helper(Yardımcı classların ve methodların bulunduğu katmandır.Business Logicler sırasında yardımcı kodlar barındırmaktadır.)

  İş akışı;
   View --> Bloc --> Services (Model,Helper ve Core katmanı ilgili iş akışına göre ilgili katmanda kullanılmaktadır.)
  ya da
   View <-- Bloc <-- Services (Model,Helper ve Core katmanı ilgili iş akışına göre ilgili katmanda kullanılmaktadır.)















