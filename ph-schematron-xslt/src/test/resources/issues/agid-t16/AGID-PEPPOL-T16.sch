<?xml version="1.0" encoding="UTF-8"?>
<!--
	Peppol BIS 3.0.6 hotfix
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Rules for the transaction of the PEPPOL Despatch Advice, version 3.1</title>
    
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2"
       prefix="ubl"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>
    
    

    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod11"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>

    

    <pattern>
 
		    <rule context="//*[not(*) and not(normalize-space())]">
			      <assert id="PEPPOL-COMMON-R001" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
		    </rule> 
   
   </pattern>
    <pattern>

      <rule context="/*">
        <assert id="PEPPOL-COMMON-R003"
                 test="not(@*:schemaLocation)"
                 flag="warning">Document SHOULD not contain schema location.</assert>

      </rule>

      <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
        <assert id="PEPPOL-COMMON-R030"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
      </rule>

    
      <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
        <assert id="PEPPOL-COMMON-R040"
                 test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"
                 flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
        <assert id="PEPPOL-COMMON-R041"
                 test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"
                 flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
      </rule>

   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957', '\s')"/>
      <let name="clUNECERec21"
           value="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV OA OB OC OD OE OF OK OT OU P2 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ ', '\s')"/>
      <let name="clUNCL6313-T16" value="tokenize('AAB AAW', '\s')"/>
      <let name="clUNCL8273"
           value="tokenize('ADR ADS ADT ADU ADV ADW ADX AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')"/>
      <let name="clUNECERec20"
           value="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMQ HMT HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NU NX OA ODE OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY', '\s')"/>
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209', '\s')"/>
      <rule context="/ubl:DespatchAdvice">
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T16-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T16-B00102">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B00103">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T16-B00104">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cac:DespatchSupplierParty"
                 flag="fatal"
                 id="PEPPOL-T16-B00105">Element 'cac:DespatchSupplierParty' MUST be provided.</assert>
         <assert test="cac:DeliveryCustomerParty"
                 flag="fatal"
                 id="PEPPOL-T16-B00106">Element 'cac:DeliveryCustomerParty' MUST be provided.</assert>
         <assert test="cac:DespatchLine" flag="fatal" id="PEPPOL-T16-B00107">Element 'cac:DespatchLine' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T16-B00108">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cbc:CustomizationID"/>
      <rule context="/ubl:DespatchAdvice/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'"
                 flag="fatal"
                 id="PEPPOL-T16-B00301">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cbc:IssueDate"/>
      <rule context="/ubl:DespatchAdvice/cbc:IssueTime"/>
      <rule context="/ubl:DespatchAdvice/cbc:Note"/>
      <rule context="/ubl:DespatchAdvice/cac:OrderReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B00801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OrderReference/cbc:ID"/>
	  <!-- Customized (extended) -->
      <rule context="/ubl:DespatchAdvice/cac:OrderReference/cbc:CustomerReference"/>
      <rule context="/ubl:DespatchAdvice/cac:OrderReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B00802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference"/>
	  <rule context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:ID"/>
	  <rule context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:IssueDate"/>
	  <rule context="/ubl:DespatchAdvice/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T16-B01001">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T16-B01101">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T16-B01102">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T16-B01201">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B01202">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B01401">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B01501">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T16-B01701">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B02501">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B02601">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B02502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B01702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T16-B02701">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B02702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B02901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B01103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B01002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T16-B03301">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T16-B03401">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T16-B03402">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T16-B03501">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B03502">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B03701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B03801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T16-B04001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B04801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B04901">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B04802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B04002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T16-B05001">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B05002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B03403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Telephone"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:ElectronicMail"/>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B05201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B03302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T16-B05601">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B05801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B05901">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B06101">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T16-B06301">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B07101">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B07201">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B07102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B06302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B05701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B05602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T16-B07301">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B07501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B07601">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B07801">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T16-B08001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B08801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B08901">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B08802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B08002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B07401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:SellerSupplierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B07302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T16-B09001">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B09201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B09301">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B09501">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T16-B09701">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B10501">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B10601">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B10502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B09702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B09101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B09002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B10701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cbc:Information"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B11001">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B11002">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B11201">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B11202">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B11501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty"/>
	  <!-- Customized (extended) -->
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B11901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name"/>
	  <!-- Customized (extended) -->
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T16-B12101">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B12201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B12202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B12102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B11801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B11502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartTime"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndTime"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B12701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:StreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CityName"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:PostalZone"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T16-B14401">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B14501">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B14402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B13501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B13201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B12501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:Shipment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B10702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B14601">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cac:OrderLineReference" flag="fatal" id="PEPPOL-T16-B14602">Element 'cac:OrderLineReference' MUST be provided.</assert>
         <assert test="cac:Item" flag="fatal" id="PEPPOL-T16-B14603">Element 'cac:Item' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:Note"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:DeliveredQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B14901">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B14902">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B15101">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B15102">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingReason"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference">
         <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T16-B15401">Element 'cbc:LineID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cbc:LineID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B15601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B15602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B15402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
	  <!-- Customized (extended) -->
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:IssueDate"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:DocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B15801">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackQuantity"/>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:PackSizeNumeric"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:Name"/>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:AdditionalInformation"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B16001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B16002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B16201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B16202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B16501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T16-B16601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T16-B16602">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B16502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem"/>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode">
         <assert test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B17001">Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</assert>
      </rule>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:TechnicalName"/>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:CategoryName"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B16901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T16-B17201">Element 'cbc:Name' MUST be provided.</assert>
         <assert test="cbc:Value" flag="fatal" id="PEPPOL-T16-B17202">Element 'cbc:Value' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode">
         <assert test="@listID" flag="fatal" id="PEPPOL-T16-B17401">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B17701">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B17702">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B17203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:ManufactureDate"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:SerialID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:ExpiryDate"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B18401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B18001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B15802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B18701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:ID">
         <assert test="normalize-space(text()) = 'NA'"
                 flag="fatal"
                 id="PEPPOL-T16-B18801">Element 'cbc:ID' MUST contain value 'NA'.</assert>
      </rule>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:HandlingCode"/>
	  <!-- Customized (extended) -->
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:AttributeID"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:Measure"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:AttributeID"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:Measure"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:AttributeID"/>
	  <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:Measure"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode">
         <assert test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B19101">Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension">
         <assert test="cbc:AttributeID" flag="fatal" id="PEPPOL-T16-B19401">Element 'cbc:AttributeID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID">
         <assert test="(some $code in $clUNCL6313-T16 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B19501">Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T16-B19601">Attribute 'unitCode' MUST be present.</assert>
         <assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"
                 flag="fatal"
                 id="PEPPOL-T16-B19602">Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B19402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T16-B19801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:ID"/>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/cbc:PackagingTypeCode">
         <assert test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T16-B20001">Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:Package/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B19802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B18901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B18702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/cac:DespatchLine/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B14604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:DespatchAdvice/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T16-B00109">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>

	     <rule context="cbc:CustomizationID">
			      <assert id="PEPPOL-T16-R011"
                 test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3')"
                 flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3'.</assert>
	     </rule>

	     <rule context="cac:BuyerCustomerParty">
		       <assert id="PEPPOL-T16-R008"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	     </rule>
	
	     <rule context="cac:SellerSupplierParty">
		       <assert id="PEPPOL-T16-R009"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	     </rule>
	     <rule context="cac:OriginatorCustomerParty">
		       <assert id="PEPPOL-T16-R010"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	     </rule>
	
	     <rule context="cac:DespatchLine">
		       <assert id="PEPPOL-T16-R003"
                 test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)"
                 flag="fatal">Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
		       <assert id="PEPPOL-T16-R004" test="(cac:Item/cbc:Name)" flag="fatal">Each Despatch Advice SHALL contain the item name</assert>
		       <assert id="PEPPOL-T16-R005" test="(cbc:DeliveredQuantity)" flag="warning">Each despatch advice line SHOULD have a delivered quantity</assert>
		       <assert id="PEPPOL-T16-R006"
                 test="number(cbc:DeliveredQuantity) &gt;= 0"
                 flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
		       <assert id="PEPPOL-T16-R007"
                 test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)"
                 flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
	     </rule>


   </pattern>
   
	<!-- AGID rules -->
	<!-- ======================== -->
	<include href="AGID/AGID-PEPPOL-T16.sch"/>
	
</schema>
