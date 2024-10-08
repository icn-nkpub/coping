// ignore_for_file: constant_identifier_names, unused_element

import 'package:flutter/material.dart';

const _src = '''
<svg version="1.1" viewBox="0 0 600 600" xmlns="http://www.w3.org/2000/svg">
   <rect width="600" height="600" ry="80" fill="#bacbac" stop-color="#000000"/>
 <g>
  <circle display="none" id="body" cx="360" cy="600" r="160" fill="#00f" stroke="#000080" stroke-linecap="round" stroke-linejoin="round" stroke-width="40"/>
  <path display="none" id="head" d="m290.7 140.16a160 100.01 0 0 0-70.697 13.23 160 100.01 0 0 0-80 86.613v120a160 160.01 0 0 0 80 138.57 160 160.01 0 0 0 160 0 160 160.01 0 0 0 80-138.57v-120a160 100.01 0 0 0-80-86.613 160 100.01 0 0 0-89.303-13.23z" fill="#00f" stroke="#000080" stroke-width="40"/>
  <g display="none" id="face">
   <g fill="#f00">
    <path display="none" id="month-passive" d="m240 400v40h120v-40z"/>
    <path display="none" id="month-smile" d="m240 400s0 40 60 40 60-40 60-40zm0 0s0 40 60 40 60-40 60-40zm0 0s0 40 60 40 60-40 60-40zm0 0s0 40 60 40 60-40 60-40z"/>
    <path display="none" id="month-grin" d="m240 400v40h80a40 40 0 0 0 20-5.3594 40 40 0 0 0 20-34.641h-80z"/>
    <g display="none" id="month-zip">
     <path d="m240 400v20h20v-20z"/>
     <path d="m260 420v20h20v-20z"/>
     <path d="m280 400v20h20v-20z"/>
     <path d="m300 420v20h20v-20z"/>
     <path d="m320 400v20h20v-20z"/>
     <path d="m340 420v20h20v-20z"/>
    </g>
   </g>
   <path display="none" id="month-bacon" d="m260 420c40 0 40 20 100 0" fill="none" stroke="#f00" stroke-linecap="square" stroke-linejoin="round" stroke-width="40"/>
   <path display="none" id="month-cringe" d="m260 420c60-20 60 20 140-20" fill="none" stroke="#f00" stroke-linecap="square" stroke-linejoin="round" stroke-width="40"/>
   <path display="none" id="leye-back" d="m220 300a60 60 0 0 1-60 60 60 60 0 0 1-60-60 60 60 0 0 1 60-60 60 60 0 0 1 60 60z" fill="#ffb380"/>
   <path display="none" id="reye-back" d="m340 360a60 60 0 0 1-60-60 60 60 0 0 1 60-60 60 60 0 0 1 60 60 60 60 0 0 1-60 60z" fill="#ffb380"/>
   <g display="none" id="glasses-arm" fill="none" stroke="#f60" stroke-width="40">
    <path d="m340 240h-180"/>
    <path d="m220 300h60"/>
   </g>
   <g fill="#f95" display="none" id="eye-emotions">
    <rect display="none" id="ee-l-uplid" x="120" y="240" width="80" height="40"/>
    <rect display="none" id="ee-r-uplid" x="300" y="240" width="80" height="40"/>
    <rect display="none" id="ee-l-downlid" x="120" y="320" width="80" height="40"/>
    <rect display="none" id="ee-r-downlid" x="300" y="320" width="80" height="40"/>
    <rect display="none" id="ee-r-sidelid" transform="rotate(-30)" x="104.45" y="449.81" width="80" height="40"/>
    <rect display="none" id="ee-l-sidelid" transform="matrix(-.86603 -.5 -.5 .86603 0 0)" x="-328.56" y="199.81" width="80" height="40"/>
   </g>
   <g transform="matrix(1 0 0 -1 -4.641 611.96)" fill="#f95">
    <rect display="none" id="ee-r-upsidelid" transform="rotate(30)" x="414.45" y="117.85" width="80" height="40"/>
    <rect display="none" id="ee-l-upsidelid" transform="matrix(-.86603 .5 .5 .86603 0 0)" x="-26.603" y="372.49" width="80" height="40"/>
   </g>
   <path display="none" id="eyeoutline-l" d="m220 300a60 60 0 0 1-60 60 60 60 0 0 1-60-60 60 60 0 0 1 60-60 60 60 0 0 1 60 60z" fill="none" stroke="#f60" stroke-width="40"/>
   <path display="none" id="eyeoutline-r" d="m340 360a60 60 0 0 1-60-60 60 60 0 0 1 60-60 60 60 0 0 1 60 60 60 60 0 0 1-60 60z" fill="none" stroke="#f60" stroke-width="40"/>
  </g>
 </g>
 <g display="none" id="cosmetics">
  <path display="none" id="mask" d="m440 380s-20 120-140 120-140-120-140-120 27.023 3.0634 40 0c14.508-3.425 25.492-16.575 40-20 6.4883-1.5317 13.512-1.5317 20 0 14.508 3.425 25.492 16.575 40 20 45.418 10.722 140 0 140 0z" fill="#fff"/>
  <g display="none" id="square-glasses" fill="none" stroke="#f60" stroke-linecap="square" stroke-width="40">
   <rect x="100" y="240" width="120" height="120"/>
   <rect x="280" y="240" width="120" height="120"/>
  </g>
  <circle display="none" id="3rd-eye" cx="240" cy="200" r="60" fill="#ffb380" stroke="#f60" stroke-linecap="square" stroke-linejoin="round" stroke-width="40"/>
 </g>
</svg>
''';

const _feat_body_id = 'body';
const _feat_head_id = 'head';
const _feat_face_id = 'face';
const _feat_month_passive_id = 'month-passive';
const _feat_month_smile_id = 'month-smile';
const _feat_month_grin_id = 'month-grin';
const _feat_month_zip_id = 'month-zip';
const _feat_month_bacon_id = 'month-bacon';
const _feat_month_cringe_id = 'month-cringe';
const _feat_leye_back_id = 'leye-back';
const _feat_reye_back_id = 'reye-back';
const _feat_glasses_arm_id = 'glasses-arm';
const _feat_eye_emotions_id = 'eye-emotions';
const _feat_ee_l_uplid_id = 'ee-l-uplid';
const _feat_ee_r_uplid_id = 'ee-r-uplid';
const _feat_ee_l_downlid_id = 'ee-l-downlid';
const _feat_ee_r_downlid_id = 'ee-r-downlid';
const _feat_ee_l_sidelid_id = 'ee-l-sidelid';
const _feat_ee_r_sidelid_id = 'ee-r-sidelid';
const _feat_ee_r_upsidelid_id = 'ee-r-upsidelid';
const _feat_ee_l_upsidelid_id = 'ee-l-upsidelid';
const _feat_eyeoutline_l_id = 'eyeoutline-l';
const _feat_eyeoutline_r_id = 'eyeoutline-r';
const _feat_cosmetics_id = 'cosmetics';
const _feat_mask_id = 'mask';
const _feat_square_glasses_id = 'square-glasses';
const _feat_3rd_eye_id = '3rd-eye';

const base58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
int naiveBase58At(final String address, final int at) =>
    base58.indexOf(address[at]);
String addressatedGuess(
        final String address, final int at, final List<String> choice) =>
    choice[(naiveBase58At(address, at) +
            naiveBase58At(address, at + 1) +
            naiveBase58At(address, at + 2)) %
        choice.length];

String cth(final Color c) => '#${c.value.toRadixString(16).substring(2)}';

String nftGen(final String address) {
  String t = _src;

  void toggle(final String w) {
    t = t.replaceAll('display="none" id="$w', 'id="$w');
  }

  toggle(_feat_body_id);
  toggle(_feat_head_id);
  toggle(_feat_face_id);
  toggle(addressatedGuess(address, 4, [
    _feat_month_passive_id,
    _feat_month_smile_id,
    _feat_month_grin_id,
    _feat_month_zip_id,
    _feat_month_bacon_id,
    _feat_month_cringe_id,
  ]));

  toggle(_feat_eyeoutline_l_id);
  toggle(_feat_eyeoutline_r_id);
  toggle(_feat_leye_back_id);
  toggle(_feat_reye_back_id);

  toggle(_feat_eye_emotions_id);
  toggle(addressatedGuess(address, 8, [
    _feat_ee_l_uplid_id,
    _feat_ee_l_downlid_id,
    _feat_ee_l_sidelid_id,
    _feat_ee_l_upsidelid_id,
  ]));
  toggle(addressatedGuess(address, 8, [
    _feat_ee_r_uplid_id,
    _feat_ee_r_downlid_id,
    _feat_ee_r_sidelid_id,
    _feat_ee_r_upsidelid_id,
  ]));

  // toggle(_feat_cosmetics_id);
  // toggle(addressatedGuess(address, 16, [
  //   _feat_mask_id,
  //   _feat_square_glasses_id,
  //   _feat_3rd_eye_id,
  //   ...base58.split(''), // to make cosmetics rare
  // ]));

  final HSLColor v = keyColor(address);
  final av = v.withHue(
      1 + ((naiveBase58At(address, 0) + naiveBase58At(address, 2)) / 2 % 360));
  final bv = v.withHue(
      2 + ((naiveBase58At(address, 1) + naiveBase58At(address, 3)) / 3 % 360));

  t = t.replaceAll(
      '#000080', cth(v.withLightness(.6).toColor())); // skin outline
  t = t.replaceAll('#00f', cth(v.withLightness(.65).toColor())); // skin fill
  t = t.replaceAll('#f00', cth(bv.withLightness(.5).toColor())); // month
  t = t.replaceAll(
      '#f60', cth(av.withLightness(.55).toColor())); // glasses frame
  t = t.replaceAll('#f95', cth(av.withLightness(.7).toColor())); // eye lid
  t = t.replaceAll('#ffb380', cth(bv.withLightness(.7).toColor())); // eye back
  t = t.replaceAll('#bacbac', cth(v.withLightness(.8).toColor())); // bg
  // t = t.replaceAll('#fff', '#fff'); // face mask

  return t;
}

HSLColor keyColor(final String address) {
  double key = 0;
  for (var i = 0; i < address.length; i++) {
    key += naiveBase58At(address, i);
  }

  return HSLColor.fromAHSL(1, key % 360, 1, .5);
}
