/*
* Used to facilitate transfer of data regarding configuration settings between an
* exterior object to a SnekGame instance
 */
class Settings {
  bool isInGroovyMode;
  bool isTurbo;

  Settings({this.isInGroovyMode = false, this.isTurbo = false});
}
