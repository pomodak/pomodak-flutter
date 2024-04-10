import 'package:flutter/material.dart';

void showPrivacyPolicyModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white,
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left, size: 32),
            ),
            centerTitle: true,
            title: const Text(
              "개인정보 처리방침",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto_Serif_KR',
              ),
            ),
          ),
          body: const Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "뽀모닭은 애플리케이션 이용자들의 개인정보보호를 중요하게 여기며 정보통신망이용촉진 및 정보보호 등에 관한 법률상의 개인정보보호 규정 및 정보통신부가 제정한 개인정보보호지침을 준수합니다. 애플리케이션 이용자의 개인정보에 대한 뽀모닭의 정책은 다음과 같습니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "1. 개인정보의 수집 및 이용 목적 개인정보는 이메일주소 등의 사항으로 당사 회원 개인을 식별할 수 있는 정보(당해 정보만으로는 특정 개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함)를 말합니다.\n뽀모닭은 다음과 같은 목적을 위하여 개인정보를 수집합니다. \n이메일주소 : 회원의 본인식별 및 불량회원의 부정한 이용 재발 방지를 위해 수집됩니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "2. 수집하는 개인정보 항목 및 수집방법 뽀모닭은 서비스 제공을 위한 필수적인 개인정보를 최초 회원가입 시 받고 있습니다. 회원가입 시 받는 필수적인 정보는 이메일주소 입니다. 설문조사나 이벤트 시 집단적인 통계분석을 위해서나 경품발송을 위한 목적으로 별도의 개인정보 기재를 요청할 수 있습니다. 이때에도 기입하신 정보는 해당 서비스 제공이나 사전에 밝힌 목적 이외의 다른 어떠한 목적으로도 사용되지 않습니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "3. 개인정보 수집에 대한 동의 뽀모닭은 회원가입 절차 중 이용약관과 개인정보보호정책에 대해「동의」또는「취소」버튼을 클릭할 수 있는 절차를 마련하고 있으며「동의」버튼을 클릭하면 개인정보 수집 및 이용에 대해 동의한 것으로 봅니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "4. 개인정보 보유 및 이용기간 이용자가 회원으로서 뽀모닭에서 제공하는서비스를 이용하는 동안 뽀모닭은 이용자들의 개인정보를 계속적으로보유하며 서비스 제공 등을 위해 이용합니다. 귀하의 개인정보는 그수집목적 또는 제공받은 목적이 달성되거나 귀하가 이용계약 해지를 요청한경우 파기하는 것을 원칙으로 하며, 이 경우 귀하의 개인정보는 재생할 수없는 방법에 의하여 시스템에서 완전히 삭제되며 어떠한 용도로도 열람또는 이용할 수 없도록 처리됩니다.\n또한, 일시적인 목적(설문조사, 이벤트)으로 입력 받은 개인정보는그 목적이 달성된 이후에는 동일한 방법으로 사후 재생이 불가능한방법으로 처리됩니다.\n다만, 당사는 이용자의 권리 남용, 악용 방지, 권리침해/명예훼손분쟁 및 수사협조 의뢰에 대비하여 회원의 이용계약 해지 시로부터 1년동안회원의 개인정보를 보관합니다.\n상법,전자상거래등에서의 소비자보호에 관한 법률 등 관계법령의규정에 의하여 보존할 필요가 있는 경우 뽀모닭은 관계법령에서 정한일정한 기간 동안 회원정보를 보관합니다.\n이 경우 뽀모닭은 보관하는 정보를 그 보관의 목적으로만 이용하며보존기간은 아래와 같습니다.\n계약 또는 청약철회 등에 관한 기록 : 5년 대금결제 및 재화등의공급에 관한 기록 : 5년 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "5. 수집한 개인정보의 제공 및 공유 뽀모닭은 더 나은 서비스를 위해 이용자의 개인정보를 제휴사 등에게 제공할 수 있으나, 이때에는 반드시 개인정보를 제공 받는 자가 누구인지, 제공 받는 자가 어떠한 목적으로 이용하는지, 제공하는 개인정보 항목이 무엇인지를 밝히고 정보주체로부터 동의 절차를 거치게 되며 동의하지 않는 경우 추가적인 정보를 수집하거나 비즈니스 파트너와 공유하지 않습니다. 단, 법령에 따른 요청이 있는 경우와 시장조사나 학술연구 등을 위하여 특정 개인을 식별할 수 없는 형태로 제공하는 경우에는 이용자의 동의 없이 개인정보를 제공할 수 있습니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "6. 개인정보의 열람, 정정, 철회 이용자는 언제든지 등록되어 있는 자신의 개인정보를 열람하거나 수정할 수 있으며 가입해지를 요청할 수 있습니다.\n개인정보 열람 및 정정은 설정 &gt; 내 계정 관리를 통하여 이용 가능합니다.\n이용자 및 법정대리인의 권리와 그 행사방법\n 정보주체는 뽀모닭에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.\n1) 개인정보 열람 요구\n2) 오류 등이 있을 경우 정정 요구\n3) 삭제 요구\n4) 처리정지 요구\n② 제1항에 따른 권리 행사는 뽀모닭에 대해 이메일을 통하여 하실 수 있으며 뽀모닭은 이에 대해 지체 없이 조치하겠습니다.\n③ 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 뽀모닭은 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.\n 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.\n⑤ 정보주체는 개인정보보호법 등 관계법령을 위반하여 뽀모닭이 처리하고 있는 정보주체 본인이나 타인의 개인정보 및 사생활을 침해하여서는 아니 됩니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "7. 뽀모닭은 사용자의 선택에 따라 소셜 로그인(이하 “OAuth“라고 함)을 사용할 수 있도록 제공하고 있습니다. OAuth 서비스 제공자의 OAuth 서비스를 이용하고자 할 경우 다음의 필수 정보를 입력하여야 합니다.\n1) 이용자 ID OAuth를 제공하는 서비스의 이용자ID\n2) 이메일 OAuth를 제공하는 서비스에 등록되고 접근이 허락된 이용자 이메일 주소\n3) 이름 OAuth를 제공하는 서비스에 등록된 이용자명, 별칭\n또한, OAuth Service 제공자의 OAuth 서비스 이용 시 사용자의 테이터에 액세스, 사용 할 수 있습니다. OAuth Service 제공자의 OAuth 서비스 이용과정에서 자동생성 정보는 아래와 같습니다.\nOAuth Service 제공자에게 전달받은 Token 정보\n뽀모닭은 OAuth Service를 이용하여 제공받은 데이터나 개인정보는 저장하지 않습니다.\nOAuth Service의 이용을 원치 않는 경우 언제든지 연결 해제 버튼을 클릭하여 연결을 해제할 수 있으며 저장되어 있는 Token 정보를 삭제할 수 있습니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "8. 개인정보의 위탁 뽀모닭은 서비스 향상을 위해서 이용자들의 개인정보를 외부전문업체에 위탁하여 처리할 수 있습니다.\n개인정보의 처리를 위탁하는 경우에는 수탁자, 위탁기간, 서비스제공자와 수탁자와의 관계 및 책임범위 등에 관한 사항을 서면, 전자우편, 전화 또는 홈페이지를 통해 미리 그 사실을 공지할 것입니다.\n또한 위탁계약 등을 통하여 서비스제공자의 개인정보보호 관련 지시엄수, 개인정보에 관한 비밀유지, 제3자 제공의 금지 및 사고시의 책임부담 등을 명확히 규정하고 당해 계약내용을 서면 또는 전자적으로 보관할 것입니다.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "9. 개인정보침해 관련 상담 및 신고 개인정보침해에 관한 상담이 필요한 경우에는 정부에서 설치하여 운영 중인 아래의 기관(개인정보침해신고센터, 개인정보 분쟁조정위원회, 정보보호마크 인증위원회, 경찰청)으로 문의하실 수 있습니다.\n개인정보 침해신고센터 (http://www.cyberprivacy.or.kr, 전화 1336) 개인정보 분쟁조정위원회 (http://www.kopico.or.kr, 전화 1336) 정보보호마크 인증위원회 (http://www.privacymark.or.kr, 전화 02-580-0533) 경찰청 (http://www.police.go.kr)",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "10. 개인정보 관리책임자 뽀모닭은 이용자의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 개인정보관리책임자를 두고 있습니다.\n다만 이용자 개인정보와 관련한 아이디와 비밀번호에 대한 보안유지책임은 해당 이용자 자신에게 있으므로 타인에게 비밀번호가 유출되지 않도록 주의해 주시기 바랍니다.\n개인정보와 관련한 문의사항이 있으면 아래의 개인정보관리책임자에게 연락주시기 바랍니다.\n개인정보 및 청소년보호 책임자\n이 름 : 이창우\n연락처 : 010-3240-3606\n이메일 lcwoo3145@gmail.com",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "11. 정책변경에 따른 고지의무 이 개인정보보호방침은 2024년 3월 16일에 제정되었으며, 법령 정책 또는 보안기술의 변경에 따라 내용의 추가, 삭제 및 수정이 있을 시에는 변경되는 개인정보보호정책을 시행하기 최소 7일전에 홈페이지 공지사항을 통해 공지하도록 하겠습니다.\n단, 중요한 사항이 변경되는 경우(제3자 제공, 수집?이용목적 변경, 보유기간 변경)에는 이용자의 동의를 얻도록 하겠습니다.\n공고 및 시행일자 : 2024년 03월 16일",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Noto_Serif_KR',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
