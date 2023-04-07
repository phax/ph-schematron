<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<transform xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <ns0:Description xmlns:ns0="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
      <ns1:Agent>
        <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns2:prefLabel>
        <ns2:schxslt.compile.typed-variables xmlns:ns2="https://doi.org/10.5281/zenodo.1495494#">true</ns2:schxslt.compile.typed-variables>
      </ns1:Agent>
    </ns1:creator>
    <ns1:created xmlns:ns1="http://purl.org/dc/terms/">2022-11-17T08:43:08.248+01:00</ns1:created>
  </ns0:Description>
  <output indent="yes" />
  <template match="root()">
    <variable as="element()?" name="metadata">
      <ns0:metadata xmlns:ns0="http://purl.oclc.org/dsdl/svrl">
        <ns1:creator xmlns:ns1="http://purl.org/dc/terms/">
          <ns1:Agent>
            <ns2:prefLabel xmlns:ns2="http://www.w3.org/2004/02/skos/core#">
              <value-of select="(system-property('xsl:product-name'), system-property('xsl:product-version'))" separator="/" />
            </ns2:prefLabel>
          </ns1:Agent>
        </ns1:creator>
        <ns1:created xmlns:ns1="http://purl.org/dc/terms/">
          <value-of select="current-dateTime()" />
        </ns1:created>
        <ns1:source xmlns:ns1="http://purl.org/dc/terms/">
          <ns2:Description xmlns:ns2="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <ns1:creator>
              <ns1:Agent>
                <ns3:prefLabel xmlns:ns3="http://www.w3.org/2004/02/skos/core#">SchXslt/1.9.4 SAXON/HE 11.4</ns3:prefLabel>
                <ns3:schxslt.compile.typed-variables xmlns:ns3="https://doi.org/10.5281/zenodo.1495494#">true</ns3:schxslt.compile.typed-variables>
              </ns1:Agent>
            </ns1:creator>
            <ns1:created>2022-11-17T08:43:08.248+01:00</ns1:created>
          </ns2:Description>
        </ns1:source>
      </ns0:metadata>
    </variable>
    <variable as="element(schxslt:report)" name="report">
      <ns0:report xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
        <call-template name="w871aac13" />
      </ns0:report>
    </variable>
    <variable as="node()*" name="schxslt:report">
      <sequence select="$metadata" />
      <for-each select="$report/schxslt:document">
        <for-each select="schxslt:pattern">
          <sequence select="node()" />
          <sequence select="../schxslt:rule[@pattern = current()/@id]/node()" />
        </for-each>
      </for-each>
    </variable>
    <ns0:schematron-output xmlns:ns0="http://purl.oclc.org/dsdl/svrl" title="EUGEN T15 bound to UBL">
      <ns0:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <ns0:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <sequence select="$schxslt:report" />
    </ns0:schematron-output>
  </template>
  <template match="text() | @*" mode="#all" priority="-10" />
  <template match="/" mode="#all" priority="-10">
    <apply-templates mode="#current" select="node()" />
  </template>
  <template match="*" mode="#all" priority="-10">
    <apply-templates mode="#current" select="@*" />
    <apply-templates mode="#current" select="node()" />
  </template>
  <template name="w871aac13">
    <ns0:document xmlns:ns0="https://doi.org/10.5281/zenodo.1495494">
      <ns0:pattern id="w871aac13">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="Codes-T15" name="Codes-T15">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <ns0:pattern id="w871aac15">
        <if test="exists(base-uri(root()))">
          <attribute name="documents" select="base-uri(root())" />
        </if>
        <for-each select="root()">
          <ns1:active-pattern xmlns:ns1="http://purl.oclc.org/dsdl/svrl" id="UBL-T15" name="UBL-T15">
            <attribute name="documents" select="base-uri(.)" />
          </ns1:active-pattern>
        </for-each>
      </ns0:pattern>
      <apply-templates mode="w871aac13" select="root()" />
    </ns0:document>
  </template>
  <template match="@mimeCode" mode="w871aac13" priority="20">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "@mimeCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">@mimeCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">@mimeCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�application/CSTAdata+xml�application/EDI-Consent�application/EDI-X12�application/EDIFACT�application/H224�application/activemessage�application/andrew-inset�application/applefile�application/atom+xml�application/atomcat+xml�application/atomicmail�application/atomsvc+xml�application/auth-policy+xml�application/batch-SMTP�application/beep+xml�application/cals-1840�application/ccxml+xml�application/cellml+xml�application/cnrp+xml�application/commonground�application/conference-info+xml�application/cpl+xml�application/csta+xml�application/cybercash�application/davmount+xml�application/dca-rft�application/dec-dx�application/dialog-info+xml�application/dicom�application/dns�application/dvcs�application/ecmascript�application/epp+xml�application/eshop�application/example�application/fastinfoset�application/fastsoap�application/fits�application/font-tdpfr�application/http�application/hyperstudio�application/iges�application/im-iscomposing+xml�application/index�application/index.cmd�application/index.obj�application/index.response�application/index.vnd�application/iotp�application/ipp�application/isup�application/javascript�application/json�application/kpml-request+xml�application/kpml-response+xml�application/mac-binhex40�application/macwriteii�application/marc�application/mathematica�application/mbms-associated-procedure-description+xml�application/mbms-deregister+xml�application/mbms-envelope+xml�application/mbms-msk+xml�application/mbms-msk-response+xml�application/mbms-protection-description+xml�application/mbms-reception-report+xml�application/mbms-register+xml�application/mbms-register-response+xml�application/mbms-user-service-description+xml�application/mbox�application/media_control+xml�application/mediaservercontrol+xml�application/mikey�application/moss-keys�application/moss-signature�application/mosskey-data�application/mosskey-request�application/mp4�application/mpeg4-generic�application/mpeg4-iod�application/mpeg4-iod-xmt�application/msword�application/mxf�application/nasdata�application/news-message-id�application/news-transmission�application/nss�application/ocsp-request�application/ocsp-response�application/octet-stream�application/oda�application/oebps-package+xml�application/ogg�application/parityfec�application/pdf�application/pgp-encrypted�application/pgp-keys�application/pgp-signature�application/pidf+xml�application/pkcs10�application/pkcs7-mime�application/pkcs7-signature�application/pkix-cert�application/pkix-crl�application/pkix-pkipath�application/pkixcmp�application/pls+xml�application/poc-settings+xml�application/postscript�application/prs.alvestrand.titrax-sheet�application/prs.cww�application/prs.nprend�application/prs.plucker�application/qsig�application/rdf+xml�application/reginfo+xml�application/relax-ng-compact-syntax�application/remote-printing�application/resource-lists+xml�application/riscos�application/rlmi+xml�application/rls-services+xml�application/rtf�application/rtx�application/samlassertion+xml�application/samlmetadata+xml�application/sbml+xml�application/scvp-cv-request�application/scvp-cv-response�application/scvp-vp-request�application/scvp-vp-response�application/sdp�application/set-payment�application/set-payment-initiation�application/set-registration�application/set-registration-initiation�application/sgml�application/sgml-open-catalog�application/shf+xml�application/sieve�application/simple-filter+xml�application/simple-message-summary�application/simpleSymbolContainer�application/slate�application/smil (OBSOLETE)�application/smil+xml�application/soap+fastinfoset�application/soap+xml�application/sparql-query�application/sparql-results+xml�application/spirits-event+xml�application/srgs�application/srgs+xml�application/ssml+xml�application/timestamp-query�application/timestamp-reply�application/tve-trigger�application/ulpfec�application/vemmi�application/vnd.3M.Post-it-Notes�application/vnd.3gpp.bsf+xml�application/vnd.3gpp.pic-bw-large�application/vnd.3gpp.pic-bw-small�application/vnd.3gpp.pic-bw-var�application/vnd.3gpp.sms�application/vnd.3gpp2.bcmcsinfo+xml�application/vnd.3gpp2.sms�application/vnd.3gpp2.tcap�application/vnd.FloGraphIt�application/vnd.HandHeld-Entertainment+xml�application/vnd.Kinar�application/vnd.MFER�application/vnd.Mobius.DAF�application/vnd.Mobius.DIS�application/vnd.Mobius.MBK�application/vnd.Mobius.MQY�application/vnd.Mobius.MSL�application/vnd.Mobius.PLC�application/vnd.Mobius.TXF�application/vnd.Quark.QuarkXPress�application/vnd.RenLearn.rlprint�application/vnd.SimTech-MindMapper�application/vnd.accpac.simply.aso�application/vnd.accpac.simply.imp�application/vnd.acucobol�application/vnd.acucorp�application/vnd.adobe.xdp+xml�application/vnd.adobe.xfdf�application/vnd.aether.imp�application/vnd.americandynamics.acc�application/vnd.amiga.ami�application/vnd.anser-web-certificate-issue-initiation�application/vnd.antix.game-component�application/vnd.apple.installer+xml�application/vnd.audiograph�application/vnd.autopackage�application/vnd.avistar+xml�application/vnd.blueice.multipass�application/vnd.bmi�application/vnd.businessobjects�application/vnd.cab-jscript�application/vnd.canon-cpdl�application/vnd.canon-lips�application/vnd.cendio.thinlinc.clientconf�application/vnd.chemdraw+xml�application/vnd.chipnuts.karaoke-mmd�application/vnd.cinderella�application/vnd.cirpack.isdn-ext�application/vnd.claymore�application/vnd.clonk.c4group�application/vnd.commerce-battelle�application/vnd.commonspace�application/vnd.contact.cmsg�application/vnd.cosmocaller�application/vnd.crick.clicker�application/vnd.crick.clicker.keyboard�application/vnd.crick.clicker.palette�application/vnd.crick.clicker.template�application/vnd.crick.clicker.wordbank�application/vnd.criticaltools.wbs+xml�application/vnd.ctc-posml�application/vnd.ctct.ws+xml�application/vnd.cups-pdf�application/vnd.cups-postscript�application/vnd.cups-ppd�application/vnd.cups-raster�application/vnd.cups-raw�application/vnd.curl�application/vnd.cybank�application/vnd.data-vision.rdz�application/vnd.denovo.fcselayout-link�application/vnd.dna�application/vnd.dpgraph�application/vnd.dreamfactory�application/vnd.dvb.esgcontainer�application/vnd.dvb.ipdcesgaccess�application/vnd.dxr�application/vnd.ecdis-update�application/vnd.ecowin.chart�application/vnd.ecowin.filerequest�application/vnd.ecowin.fileupdate�application/vnd.ecowin.series�application/vnd.ecowin.seriesrequest�application/vnd.ecowin.seriesupdate�application/vnd.enliven�application/vnd.epson.esf�application/vnd.epson.msf�application/vnd.epson.quickanime�application/vnd.epson.salt�application/vnd.epson.ssf�application/vnd.ericsson.quickcall�application/vnd.eszigno3+xml�application/vnd.eudora.data�application/vnd.ezpix-album�application/vnd.ezpix-package�application/vnd.fdf�application/vnd.ffsns�application/vnd.fints�application/vnd.fluxtime.clip�application/vnd.framemaker�application/vnd.frogans.fnc�application/vnd.frogans.ltf�application/vnd.fsc.weblaunch�application/vnd.fujitsu.oasys�application/vnd.fujitsu.oasys2�application/vnd.fujitsu.oasys3�application/vnd.fujitsu.oasysgp�application/vnd.fujitsu.oasysprs�application/vnd.fujixerox.ART-EX�application/vnd.fujixerox.ART4�application/vnd.fujixerox.HBPL�application/vnd.fujixerox.ddd�application/vnd.fujixerox.docuworks�application/vnd.fujixerox.docuworks.binder�application/vnd.fut-misnet�application/vnd.fuzzysheet�application/vnd.genomatix.tuxedo�application/vnd.google-earth.kml+xml�application/vnd.google-earth.kmz�application/vnd.grafeq�application/vnd.gridmp�application/vnd.groove-account�application/vnd.groove-help�application/vnd.groove-identity-message�application/vnd.groove-injector�application/vnd.groove-tool-message�application/vnd.groove-tool-template�application/vnd.groove-vcard�application/vnd.hbci�application/vnd.hcl-bireports�application/vnd.hhe.lesson-player�application/vnd.hp-HPGL�application/vnd.hp-PCL�application/vnd.hp-PCLXL�application/vnd.hp-hpid�application/vnd.hp-hps�application/vnd.hp-jlyt�application/vnd.httphone�application/vnd.hzn-3d-crossword�application/vnd.ibm.MiniPay�application/vnd.ibm.afplinedata�application/vnd.ibm.electronic-media�application/vnd.ibm.modcap�application/vnd.ibm.rights-management�application/vnd.ibm.secure-container�application/vnd.iccprofile�application/vnd.igloader�application/vnd.immervision-ivp�application/vnd.immervision-ivu�application/vnd.informedcontrol.rms+xml�application/vnd.informix-visionary�application/vnd.intercon.formnet�application/vnd.intertrust.digibox�application/vnd.intertrust.nncp�application/vnd.intu.qbo�application/vnd.intu.qfx�application/vnd.ipunplugged.rcprofile�application/vnd.irepository.package+xml�application/vnd.is-xpr�application/vnd.jam�application/vnd.japannet-directory-service�application/vnd.japannet-jpnstore-wakeup�application/vnd.japannet-payment-wakeup�application/vnd.japannet-registration�application/vnd.japannet-registration-wakeup�application/vnd.japannet-setstore-wakeup�application/vnd.japannet-verification�application/vnd.japannet-verification-wakeup�application/vnd.jcp.javame.midlet-rms�application/vnd.jisp�application/vnd.joost.joda-archive�application/vnd.kahootz�application/vnd.kde.karbon�application/vnd.kde.kchart�application/vnd.kde.kformula�application/vnd.kde.kivio�application/vnd.kde.kontour�application/vnd.kde.kpresenter�application/vnd.kde.kspread�application/vnd.kde.kword�application/vnd.kenameaapp�application/vnd.kidspiration�application/vnd.koan�application/vnd.kodak-descriptor�application/vnd.liberty-request+xml�application/vnd.llamagraphics.life-balance.desktop�application/vnd.llamagraphics.life-balance.exchange+xml�application/vnd.lotus-1-2-3�application/vnd.lotus-approach�application/vnd.lotus-freelance�application/vnd.lotus-notes�application/vnd.lotus-organizer�application/vnd.lotus-screencam�application/vnd.lotus-wordpro�application/vnd.macports.portpkg�application/vnd.marlin.drm.actiontoken+xml�application/vnd.marlin.drm.conftoken+xml�application/vnd.marlin.drm.mdcf�application/vnd.mcd�application/vnd.medcalcdata�application/vnd.mediastation.cdkey�application/vnd.meridian-slingshot�application/vnd.mfmp�application/vnd.micrografx.flo�application/vnd.micrografx.igx�application/vnd.mif�application/vnd.minisoft-hp3000-save�application/vnd.mitsubishi.misty-guard.trustweb�application/vnd.mophun.application�application/vnd.mophun.certificate�application/vnd.motorola.flexsuite�application/vnd.motorola.flexsuite.adsi�application/vnd.motorola.flexsuite.fis�application/vnd.motorola.flexsuite.gotap�application/vnd.motorola.flexsuite.kmr�application/vnd.motorola.flexsuite.ttc�application/vnd.motorola.flexsuite.wem�application/vnd.mozilla.xul+xml�application/vnd.ms-artgalry�application/vnd.ms-asf�application/vnd.ms-cab-compressed�application/vnd.ms-excel�application/vnd.ms-fontobject�application/vnd.ms-htmlhelp�application/vnd.ms-ims�application/vnd.ms-lrm�application/vnd.ms-playready.initiator+xml�application/vnd.ms-powerpoint�application/vnd.ms-project�application/vnd.ms-tnef�application/vnd.ms-wmdrm.lic-chlg-req�application/vnd.ms-wmdrm.lic-resp�application/vnd.ms-wmdrm.meter-chlg-req�application/vnd.ms-wmdrm.meter-resp�application/vnd.ms-works�application/vnd.ms-wpl�application/vnd.ms-xpsdocument�application/vnd.mseq�application/vnd.msign�application/vnd.multiad.creator�application/vnd.multiad.creator.cif�application/vnd.music-niff�application/vnd.musician�application/vnd.muvee.style�application/vnd.ncd.control�application/vnd.ncd.reference�application/vnd.nervana�application/vnd.netfpx�application/vnd.neurolanguage.nlu�application/vnd.noblenet-directory�application/vnd.noblenet-sealer�application/vnd.noblenet-web�application/vnd.nokia.catalogs�application/vnd.nokia.conml+wbxml�application/vnd.nokia.conml+xml�application/vnd.nokia.iSDS-radio-presets�application/vnd.nokia.iptv.config+xml�application/vnd.nokia.landmark+wbxml�application/vnd.nokia.landmark+xml�application/vnd.nokia.landmarkcollection+xml�application/vnd.nokia.n-gage.ac+xml�application/vnd.nokia.n-gage.data�application/vnd.nokia.n-gage.symbian.install�application/vnd.nokia.ncd�application/vnd.nokia.pcd+wbxml�application/vnd.nokia.pcd+xml�application/vnd.nokia.radio-preset�application/vnd.nokia.radio-presets�application/vnd.novadigm.EDM�application/vnd.novadigm.EDX�application/vnd.novadigm.EXT�application/vnd.oasis.opendocument.chart�application/vnd.oasis.opendocument.chart-template�application/vnd.oasis.opendocument.formula�application/vnd.oasis.opendocument.formula-template�application/vnd.oasis.opendocument.graphics�application/vnd.oasis.opendocument.graphics-template�application/vnd.oasis.opendocument.image�application/vnd.oasis.opendocument.image-template�application/vnd.oasis.opendocument.presentation�application/vnd.oasis.opendocument.presentation-template�application/vnd.oasis.opendocument.spreadsheet�application/vnd.oasis.opendocument.spreadsheet-template�application/vnd.oasis.opendocument.text�application/vnd.oasis.opendocument.text-master�application/vnd.oasis.opendocument.text-template�application/vnd.oasis.opendocument.text-web�application/vnd.obn�application/vnd.olpc-sugar�application/vnd.oma-scws-config�application/vnd.oma-scws-http-request�application/vnd.oma-scws-http-response�application/vnd.oma.bcast.associated-procedure-parameter+xml�application/vnd.oma.bcast.drm-trigger+xml�application/vnd.oma.bcast.imd+xml�application/vnd.oma.bcast.ltkm�application/vnd.oma.bcast.notification+xml�application/vnd.oma.bcast.sgboot�application/vnd.oma.bcast.sgdd+xml�application/vnd.oma.bcast.sgdu�application/vnd.oma.bcast.simple-symbol-container�application/vnd.oma.bcast.smartcard-trigger+xml�application/vnd.oma.bcast.sprov+xml�application/vnd.oma.bcast.stkm�application/vnd.oma.dd2+xml�application/vnd.oma.drm.risd+xml�application/vnd.oma.group-usage-list+xml�application/vnd.oma.poc.detailed-progress-report+xml�application/vnd.oma.poc.final-report+xml�application/vnd.oma.poc.groups+xml�application/vnd.oma.poc.invocation-descriptor+xml�application/vnd.oma.poc.optimized-progress-report+xml�application/vnd.oma.xcap-directory+xml�application/vnd.omads-email+xml�application/vnd.omads-file+xml�application/vnd.omads-folder+xml�application/vnd.omaloc-supl-init�application/vnd.openofficeorg.extension�application/vnd.osa.netdeploy�application/vnd.osgi.bundle�application/vnd.osgi.dp�application/vnd.otps.ct-kip+xml�application/vnd.palm�application/vnd.paos.xml�application/vnd.pg.format�application/vnd.pg.osasli�application/vnd.piaccess.application-licence�application/vnd.picsel�application/vnd.poc.group-advertisement+xml�application/vnd.pocketlearn�application/vnd.powerbuilder6�application/vnd.powerbuilder6-s�application/vnd.powerbuilder7�application/vnd.powerbuilder7-s�application/vnd.powerbuilder75�application/vnd.powerbuilder75-s�application/vnd.preminet�application/vnd.previewsystems.box�application/vnd.proteus.magazine�application/vnd.publishare-delta-tree�application/vnd.pvi.ptid1�application/vnd.pwg-multiplexed�application/vnd.pwg-xhtml-print+xml�application/vnd.qualcomm.brew-app-res�application/vnd.rapid�application/vnd.recordare.musicxml�application/vnd.recordare.musicxml+xml�application/vnd.ruckus.download�application/vnd.s3sms�application/vnd.sbm.mid2�application/vnd.scribus�application/vnd.sealed.3df�application/vnd.sealed.csf�application/vnd.sealed.doc�application/vnd.sealed.eml�application/vnd.sealed.mht�application/vnd.sealed.net�application/vnd.sealed.ppt�application/vnd.sealed.tiff�application/vnd.sealed.xls�application/vnd.sealedmedia.softseal.html�application/vnd.sealedmedia.softseal.pdf�application/vnd.seemail�application/vnd.sema�application/vnd.semd�application/vnd.semf�application/vnd.shana.informed.formdata�application/vnd.shana.informed.formtemplate�application/vnd.shana.informed.interchange�application/vnd.shana.informed.package�application/vnd.smaf�application/vnd.solent.sdkm+xml�application/vnd.spotfire.dxp�application/vnd.spotfire.sfs�application/vnd.sss-cod�application/vnd.sss-dtf�application/vnd.sss-ntf�application/vnd.street-stream�application/vnd.sun.wadl+xml�application/vnd.sus-calendar�application/vnd.svd�application/vnd.swiftview-ics�application/vnd.syncml+xml�application/vnd.syncml.dm+wbxml�application/vnd.syncml.dm+xml�application/vnd.syncml.ds.notification�application/vnd.tao.intent-module-archive�application/vnd.tmobile-livetv�application/vnd.trid.tpt�application/vnd.triscape.mxs�application/vnd.trueapp�application/vnd.truedoc�application/vnd.ufdl�application/vnd.uiq.theme�application/vnd.umajin�application/vnd.unity�application/vnd.uoml+xml�application/vnd.uplanet.alert�application/vnd.uplanet.alert-wbxml�application/vnd.uplanet.bearer-choice�application/vnd.uplanet.bearer-choice-wbxml�application/vnd.uplanet.cacheop�application/vnd.uplanet.cacheop-wbxml�application/vnd.uplanet.channel�application/vnd.uplanet.channel-wbxml�application/vnd.uplanet.list�application/vnd.uplanet.list-wbxml�application/vnd.uplanet.listcmd�application/vnd.uplanet.listcmd-wbxml�application/vnd.uplanet.signal�application/vnd.vcx�application/vnd.vd-study�application/vnd.vectorworks�application/vnd.vidsoft.vidconference�application/vnd.visio�application/vnd.visionary�application/vnd.vividence.scriptfile�application/vnd.vsf�application/vnd.wap.sic�application/vnd.wap.slc�application/vnd.wap.wbxml�application/vnd.wap.wmlc�application/vnd.wap.wmlscriptc�application/vnd.webturbo�application/vnd.wfa.wsc�application/vnd.wmc�application/vnd.wmf.bootstrap�application/vnd.wordperfect�application/vnd.wqd�application/vnd.wrq-hp3000-labelled�application/vnd.wt.stf�application/vnd.wv.csp+wbxml�application/vnd.wv.csp+xml�application/vnd.wv.ssp+xml�application/vnd.xara�application/vnd.xfdl�application/vnd.xmpie.cpkg�application/vnd.xmpie.dpkg�application/vnd.xmpie.plan�application/vnd.xmpie.ppkg�application/vnd.xmpie.xlim�application/vnd.yamaha.hv-dic�application/vnd.yamaha.hv-script�application/vnd.yamaha.hv-voice�application/vnd.yamaha.smaf-audio�application/vnd.yamaha.smaf-phrase�application/vnd.yellowriver-custom-menu�application/vnd.zzazz.deck+xml�application/voicexml+xml�application/watcherinfo+xml�application/whoispp-query�application/whoispp-response�application/wita�application/wordperfect5.1�application/wsdl+xml�application/wspolicy+xml�application/x400-bp�application/xcap-att+xml�application/xcap-caps+xml�application/xcap-el+xml�application/xcap-error+xml�application/xcap-ns+xml�application/xenc+xml�application/xhtml+xml�application/xhtml-voice+xml (Obsolete)�application/xml�application/xml-dtd�application/xml-external-parsed-entity�application/xmpp+xml�application/xop+xml�application/xv+xml�application/zip�audio/32kadpcm�audio/3gpp�audio/3gpp2�audio/AMR�audio/AMR-WB�audio/BV16�audio/BV32�audio/CN�audio/DAT12�audio/DVI4�audio/EVRC�audio/EVRC-QCP�audio/EVRC0�audio/EVRC1�audio/EVRCB�audio/EVRCB0�audio/EVRCB1�audio/EVRCWB�audio/EVRCWB0�audio/EVRCWB1�audio/G722�audio/G7221�audio/G723�audio/G726-16�audio/G726-24�audio/G726-32�audio/G726-40�audio/G728�audio/G729�audio/G7291�audio/G729D�audio/G729E�audio/GSM�audio/GSM-EFR�audio/L16�audio/L20�audio/L24�audio/L8�audio/LPC�audio/MP4A-LATM�audio/MPA�audio/PCMA�audio/PCMU�audio/QCELP�audio/RED�audio/SMV�audio/SMV-QCP�audio/SMV0�audio/VDVI�audio/VMR-WB�audio/ac3�audio/amr-wb+�audio/asc�audio/basic�audio/clearmode�audio/dls�audio/dsr-es201108�audio/dsr-es202050�audio/dsr-es202211�audio/dsr-es202212�audio/eac3�audio/example�audio/iLBC�audio/mobile-xmf�audio/mp4�audio/mpa-robust�audio/mpeg�audio/mpeg4-generic�audio/parityfec�audio/prs.sid�audio/rRFC2045tp-midi�audio/rtp-enc-aescm128�audio/rtx�audio/sp-midi�audio/t140c�audio/t38�audio/telephone-event�audio/tone�audio/ulpfec�audio/vnd.3gpp.iufp�audio/vnd.4SB�audio/vnd.CELP�audio/vnd.audiokoz�audio/vnd.cisco.nse�audio/vnd.cmles.radio-events�audio/vnd.cns.anp1�audio/vnd.cns.inf1�audio/vnd.digital-winds�audio/vnd.dlna.adts�audio/vnd.dolby.mlp�audio/vnd.everad.plj�audio/vnd.hns.audio�audio/vnd.lucent.voice�audio/vnd.nokia.mobile-xmf�audio/vnd.nortel.vbk�audio/vnd.nuera.ecelp4800�audio/vnd.nuera.ecelp7470�audio/vnd.nuera.ecelp9600�audio/vnd.octel.sbc�audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp�audio/vnd.rhetorex.32kadpcm�audio/vnd.sealedmedia.softseal.mpeg�audio/vnd.vmx.cvsd�image/cgm�image/example�image/fits�image/g3fax�image/gif�image/ief�image/jp2�image/jpeg�image/jpm�image/jpx�image/naplps�image/png�image/prs.btif�image/prs.pti�image/t38�image/tiff�image/tiff-fx�image/vnd.adobe.photoshop�image/vnd.cns.inf2�image/vnd.djvu�image/vnd.dwg�image/vnd.dxf�image/vnd.fastbidsheet�image/vnd.fpx�image/vnd.fst�image/vnd.fujixerox.edmics-mmr�image/vnd.fujixerox.edmics-rlc�image/vnd.globalgraphics.pgb�image/vnd.microsoft.icon�image/vnd.mix�image/vnd.ms-modi�image/vnd.net-fpx�image/vnd.sealed.png�image/vnd.sealedmedia.softseal.gif�image/vnd.sealedmedia.softseal.jpg�image/vnd.svf�image/vnd.wap.wbmp�image/vnd.xiff�message/CPIM�message/delivery-status�message/disposition-notification�message/example�message/external-body�message/http�message/news�message/partial�message/rfc822�message/s-http�message/sip�message/sipfrag�message/tracking-status�message/vnd.si.simp�model/example�model/iges�model/mesh�model/vnd.dwf�model/vnd.flatland.3dml�model/vnd.gdl�model/vnd.gs-gdl�model/vnd.gtw�model/vnd.moml+xml�model/vnd.mts�model/vnd.parasolid.transmit.binary�model/vnd.parasolid.transmit.text�model/vnd.vtu�model/vrml�multipart/alternative�multipart/appledouble�multipart/byteranges�multipart/digest�multipart/encrypted�multipart/example�multipart/form-data�multipart/header-set�multipart/mixed�multipart/parallel�multipart/related�multipart/report�multipart/signed�multipart/voice-message�text/RED�text/calendar�text/css�text/csv�text/directory�text/dns�text/ecmascript (obsolete)�text/enriched�text/example�text/html�text/javascript (obsolete)�text/parityfec�text/plain�text/prs.fallenstein.rst�text/prs.lines.tag�text/rfc822-headers�text/richtext�text/rtf�text/rtp-enc-aescm128�text/rtx�text/sgml�text/t140�text/tab-separated-values�text/troff�text/ulpfec�text/uri-list�text/vnd.DMClientScript�text/vnd.IPTC.NITF�text/vnd.IPTC.NewsML�text/vnd.abc�text/vnd.curl�text/vnd.esmertec.theme-descriptor�text/vnd.fly�text/vnd.fmi.flexstor�text/vnd.in3d.3dml�text/vnd.in3d.spot�text/vnd.latex-z�text/vnd.motorola.reflex�text/vnd.ms-mediapackage�text/vnd.net2phone.commcenter.command�text/vnd.si.uricatalogue�text/vnd.sun.j2me.app-descriptor�text/vnd.trolltech.linguist�text/vnd.wap.si�text/vnd.wap.sl�text/vnd.wap.wml�text/vnd.wap.wmlscript�text/xml�text/xml-external-parsed-entity�video/3gpp�video/3gpp-tt�video/3gpp2�video/BMPEG�video/BT656�video/CelB�video/DV�video/H261�video/H263�video/H263-1998�video/H263-2000�video/H264�video/JPEG�video/MJ2�video/MP1S�video/MP2P�video/MP2T�video/MP4V-ES�video/MPV�video/SMPTE292M�video/example�video/mp4�video/mpeg�video/mpeg4-generic�video/nv�video/parityfec�video/pointer�video/quicktime�video/raw�video/rtp-enc-aescm128�video/rtx�video/ulpfec�video/vc1�video/vnd.dlna.mpeg-tts�video/vnd.fvt�video/vnd.hns.video�video/vnd.iptvforum.1dparityfec-1010�video/vnd.iptvforum.1dparityfec-2005�video/vnd.iptvforum.2dparityfec-1010�video/vnd.iptvforum.2dparityfec-2005�video/vnd.iptvforum.ttsavc�video/vnd.iptvforum.ttsmpeg2�video/vnd.motorola.video�video/vnd.motorola.videop�video/vnd.mpegurl�video/vnd.nokia.interleaved-multimedia�video/vnd.nokia.videovoip�video/vnd.objectvideo�video/vnd.sealed.mpeg1�video/vnd.sealed.mpeg4�video/vnd.sealed.swf�video/vnd.sealedmedia.softseal.mov�video/vnd.vivo�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�application/CSTAdata+xml�application/EDI-Consent�application/EDI-X12�application/EDIFACT�application/H224�application/activemessage�application/andrew-inset�application/applefile�application/atom+xml�application/atomcat+xml�application/atomicmail�application/atomsvc+xml�application/auth-policy+xml�application/batch-SMTP�application/beep+xml�application/cals-1840�application/ccxml+xml�application/cellml+xml�application/cnrp+xml�application/commonground�application/conference-info+xml�application/cpl+xml�application/csta+xml�application/cybercash�application/davmount+xml�application/dca-rft�application/dec-dx�application/dialog-info+xml�application/dicom�application/dns�application/dvcs�application/ecmascript�application/epp+xml�application/eshop�application/example�application/fastinfoset�application/fastsoap�application/fits�application/font-tdpfr�application/http�application/hyperstudio�application/iges�application/im-iscomposing+xml�application/index�application/index.cmd�application/index.obj�application/index.response�application/index.vnd�application/iotp�application/ipp�application/isup�application/javascript�application/json�application/kpml-request+xml�application/kpml-response+xml�application/mac-binhex40�application/macwriteii�application/marc�application/mathematica�application/mbms-associated-procedure-description+xml�application/mbms-deregister+xml�application/mbms-envelope+xml�application/mbms-msk+xml�application/mbms-msk-response+xml�application/mbms-protection-description+xml�application/mbms-reception-report+xml�application/mbms-register+xml�application/mbms-register-response+xml�application/mbms-user-service-description+xml�application/mbox�application/media_control+xml�application/mediaservercontrol+xml�application/mikey�application/moss-keys�application/moss-signature�application/mosskey-data�application/mosskey-request�application/mp4�application/mpeg4-generic�application/mpeg4-iod�application/mpeg4-iod-xmt�application/msword�application/mxf�application/nasdata�application/news-message-id�application/news-transmission�application/nss�application/ocsp-request�application/ocsp-response�application/octet-stream�application/oda�application/oebps-package+xml�application/ogg�application/parityfec�application/pdf�application/pgp-encrypted�application/pgp-keys�application/pgp-signature�application/pidf+xml�application/pkcs10�application/pkcs7-mime�application/pkcs7-signature�application/pkix-cert�application/pkix-crl�application/pkix-pkipath�application/pkixcmp�application/pls+xml�application/poc-settings+xml�application/postscript�application/prs.alvestrand.titrax-sheet�application/prs.cww�application/prs.nprend�application/prs.plucker�application/qsig�application/rdf+xml�application/reginfo+xml�application/relax-ng-compact-syntax�application/remote-printing�application/resource-lists+xml�application/riscos�application/rlmi+xml�application/rls-services+xml�application/rtf�application/rtx�application/samlassertion+xml�application/samlmetadata+xml�application/sbml+xml�application/scvp-cv-request�application/scvp-cv-response�application/scvp-vp-request�application/scvp-vp-response�application/sdp�application/set-payment�application/set-payment-initiation�application/set-registration�application/set-registration-initiation�application/sgml�application/sgml-open-catalog�application/shf+xml�application/sieve�application/simple-filter+xml�application/simple-message-summary�application/simpleSymbolContainer�application/slate�application/smil (OBSOLETE)�application/smil+xml�application/soap+fastinfoset�application/soap+xml�application/sparql-query�application/sparql-results+xml�application/spirits-event+xml�application/srgs�application/srgs+xml�application/ssml+xml�application/timestamp-query�application/timestamp-reply�application/tve-trigger�application/ulpfec�application/vemmi�application/vnd.3M.Post-it-Notes�application/vnd.3gpp.bsf+xml�application/vnd.3gpp.pic-bw-large�application/vnd.3gpp.pic-bw-small�application/vnd.3gpp.pic-bw-var�application/vnd.3gpp.sms�application/vnd.3gpp2.bcmcsinfo+xml�application/vnd.3gpp2.sms�application/vnd.3gpp2.tcap�application/vnd.FloGraphIt�application/vnd.HandHeld-Entertainment+xml�application/vnd.Kinar�application/vnd.MFER�application/vnd.Mobius.DAF�application/vnd.Mobius.DIS�application/vnd.Mobius.MBK�application/vnd.Mobius.MQY�application/vnd.Mobius.MSL�application/vnd.Mobius.PLC�application/vnd.Mobius.TXF�application/vnd.Quark.QuarkXPress�application/vnd.RenLearn.rlprint�application/vnd.SimTech-MindMapper�application/vnd.accpac.simply.aso�application/vnd.accpac.simply.imp�application/vnd.acucobol�application/vnd.acucorp�application/vnd.adobe.xdp+xml�application/vnd.adobe.xfdf�application/vnd.aether.imp�application/vnd.americandynamics.acc�application/vnd.amiga.ami�application/vnd.anser-web-certificate-issue-initiation�application/vnd.antix.game-component�application/vnd.apple.installer+xml�application/vnd.audiograph�application/vnd.autopackage�application/vnd.avistar+xml�application/vnd.blueice.multipass�application/vnd.bmi�application/vnd.businessobjects�application/vnd.cab-jscript�application/vnd.canon-cpdl�application/vnd.canon-lips�application/vnd.cendio.thinlinc.clientconf�application/vnd.chemdraw+xml�application/vnd.chipnuts.karaoke-mmd�application/vnd.cinderella�application/vnd.cirpack.isdn-ext�application/vnd.claymore�application/vnd.clonk.c4group�application/vnd.commerce-battelle�application/vnd.commonspace�application/vnd.contact.cmsg�application/vnd.cosmocaller�application/vnd.crick.clicker�application/vnd.crick.clicker.keyboard�application/vnd.crick.clicker.palette�application/vnd.crick.clicker.template�application/vnd.crick.clicker.wordbank�application/vnd.criticaltools.wbs+xml�application/vnd.ctc-posml�application/vnd.ctct.ws+xml�application/vnd.cups-pdf�application/vnd.cups-postscript�application/vnd.cups-ppd�application/vnd.cups-raster�application/vnd.cups-raw�application/vnd.curl�application/vnd.cybank�application/vnd.data-vision.rdz�application/vnd.denovo.fcselayout-link�application/vnd.dna�application/vnd.dpgraph�application/vnd.dreamfactory�application/vnd.dvb.esgcontainer�application/vnd.dvb.ipdcesgaccess�application/vnd.dxr�application/vnd.ecdis-update�application/vnd.ecowin.chart�application/vnd.ecowin.filerequest�application/vnd.ecowin.fileupdate�application/vnd.ecowin.series�application/vnd.ecowin.seriesrequest�application/vnd.ecowin.seriesupdate�application/vnd.enliven�application/vnd.epson.esf�application/vnd.epson.msf�application/vnd.epson.quickanime�application/vnd.epson.salt�application/vnd.epson.ssf�application/vnd.ericsson.quickcall�application/vnd.eszigno3+xml�application/vnd.eudora.data�application/vnd.ezpix-album�application/vnd.ezpix-package�application/vnd.fdf�application/vnd.ffsns�application/vnd.fints�application/vnd.fluxtime.clip�application/vnd.framemaker�application/vnd.frogans.fnc�application/vnd.frogans.ltf�application/vnd.fsc.weblaunch�application/vnd.fujitsu.oasys�application/vnd.fujitsu.oasys2�application/vnd.fujitsu.oasys3�application/vnd.fujitsu.oasysgp�application/vnd.fujitsu.oasysprs�application/vnd.fujixerox.ART-EX�application/vnd.fujixerox.ART4�application/vnd.fujixerox.HBPL�application/vnd.fujixerox.ddd�application/vnd.fujixerox.docuworks�application/vnd.fujixerox.docuworks.binder�application/vnd.fut-misnet�application/vnd.fuzzysheet�application/vnd.genomatix.tuxedo�application/vnd.google-earth.kml+xml�application/vnd.google-earth.kmz�application/vnd.grafeq�application/vnd.gridmp�application/vnd.groove-account�application/vnd.groove-help�application/vnd.groove-identity-message�application/vnd.groove-injector�application/vnd.groove-tool-message�application/vnd.groove-tool-template�application/vnd.groove-vcard�application/vnd.hbci�application/vnd.hcl-bireports�application/vnd.hhe.lesson-player�application/vnd.hp-HPGL�application/vnd.hp-PCL�application/vnd.hp-PCLXL�application/vnd.hp-hpid�application/vnd.hp-hps�application/vnd.hp-jlyt�application/vnd.httphone�application/vnd.hzn-3d-crossword�application/vnd.ibm.MiniPay�application/vnd.ibm.afplinedata�application/vnd.ibm.electronic-media�application/vnd.ibm.modcap�application/vnd.ibm.rights-management�application/vnd.ibm.secure-container�application/vnd.iccprofile�application/vnd.igloader�application/vnd.immervision-ivp�application/vnd.immervision-ivu�application/vnd.informedcontrol.rms+xml�application/vnd.informix-visionary�application/vnd.intercon.formnet�application/vnd.intertrust.digibox�application/vnd.intertrust.nncp�application/vnd.intu.qbo�application/vnd.intu.qfx�application/vnd.ipunplugged.rcprofile�application/vnd.irepository.package+xml�application/vnd.is-xpr�application/vnd.jam�application/vnd.japannet-directory-service�application/vnd.japannet-jpnstore-wakeup�application/vnd.japannet-payment-wakeup�application/vnd.japannet-registration�application/vnd.japannet-registration-wakeup�application/vnd.japannet-setstore-wakeup�application/vnd.japannet-verification�application/vnd.japannet-verification-wakeup�application/vnd.jcp.javame.midlet-rms�application/vnd.jisp�application/vnd.joost.joda-archive�application/vnd.kahootz�application/vnd.kde.karbon�application/vnd.kde.kchart�application/vnd.kde.kformula�application/vnd.kde.kivio�application/vnd.kde.kontour�application/vnd.kde.kpresenter�application/vnd.kde.kspread�application/vnd.kde.kword�application/vnd.kenameaapp�application/vnd.kidspiration�application/vnd.koan�application/vnd.kodak-descriptor�application/vnd.liberty-request+xml�application/vnd.llamagraphics.life-balance.desktop�application/vnd.llamagraphics.life-balance.exchange+xml�application/vnd.lotus-1-2-3�application/vnd.lotus-approach�application/vnd.lotus-freelance�application/vnd.lotus-notes�application/vnd.lotus-organizer�application/vnd.lotus-screencam�application/vnd.lotus-wordpro�application/vnd.macports.portpkg�application/vnd.marlin.drm.actiontoken+xml�application/vnd.marlin.drm.conftoken+xml�application/vnd.marlin.drm.mdcf�application/vnd.mcd�application/vnd.medcalcdata�application/vnd.mediastation.cdkey�application/vnd.meridian-slingshot�application/vnd.mfmp�application/vnd.micrografx.flo�application/vnd.micrografx.igx�application/vnd.mif�application/vnd.minisoft-hp3000-save�application/vnd.mitsubishi.misty-guard.trustweb�application/vnd.mophun.application�application/vnd.mophun.certificate�application/vnd.motorola.flexsuite�application/vnd.motorola.flexsuite.adsi�application/vnd.motorola.flexsuite.fis�application/vnd.motorola.flexsuite.gotap�application/vnd.motorola.flexsuite.kmr�application/vnd.motorola.flexsuite.ttc�application/vnd.motorola.flexsuite.wem�application/vnd.mozilla.xul+xml�application/vnd.ms-artgalry�application/vnd.ms-asf�application/vnd.ms-cab-compressed�application/vnd.ms-excel�application/vnd.ms-fontobject�application/vnd.ms-htmlhelp�application/vnd.ms-ims�application/vnd.ms-lrm�application/vnd.ms-playready.initiator+xml�application/vnd.ms-powerpoint�application/vnd.ms-project�application/vnd.ms-tnef�application/vnd.ms-wmdrm.lic-chlg-req�application/vnd.ms-wmdrm.lic-resp�application/vnd.ms-wmdrm.meter-chlg-req�application/vnd.ms-wmdrm.meter-resp�application/vnd.ms-works�application/vnd.ms-wpl�application/vnd.ms-xpsdocument�application/vnd.mseq�application/vnd.msign�application/vnd.multiad.creator�application/vnd.multiad.creator.cif�application/vnd.music-niff�application/vnd.musician�application/vnd.muvee.style�application/vnd.ncd.control�application/vnd.ncd.reference�application/vnd.nervana�application/vnd.netfpx�application/vnd.neurolanguage.nlu�application/vnd.noblenet-directory�application/vnd.noblenet-sealer�application/vnd.noblenet-web�application/vnd.nokia.catalogs�application/vnd.nokia.conml+wbxml�application/vnd.nokia.conml+xml�application/vnd.nokia.iSDS-radio-presets�application/vnd.nokia.iptv.config+xml�application/vnd.nokia.landmark+wbxml�application/vnd.nokia.landmark+xml�application/vnd.nokia.landmarkcollection+xml�application/vnd.nokia.n-gage.ac+xml�application/vnd.nokia.n-gage.data�application/vnd.nokia.n-gage.symbian.install�application/vnd.nokia.ncd�application/vnd.nokia.pcd+wbxml�application/vnd.nokia.pcd+xml�application/vnd.nokia.radio-preset�application/vnd.nokia.radio-presets�application/vnd.novadigm.EDM�application/vnd.novadigm.EDX�application/vnd.novadigm.EXT�application/vnd.oasis.opendocument.chart�application/vnd.oasis.opendocument.chart-template�application/vnd.oasis.opendocument.formula�application/vnd.oasis.opendocument.formula-template�application/vnd.oasis.opendocument.graphics�application/vnd.oasis.opendocument.graphics-template�application/vnd.oasis.opendocument.image�application/vnd.oasis.opendocument.image-template�application/vnd.oasis.opendocument.presentation�application/vnd.oasis.opendocument.presentation-template�application/vnd.oasis.opendocument.spreadsheet�application/vnd.oasis.opendocument.spreadsheet-template�application/vnd.oasis.opendocument.text�application/vnd.oasis.opendocument.text-master�application/vnd.oasis.opendocument.text-template�application/vnd.oasis.opendocument.text-web�application/vnd.obn�application/vnd.olpc-sugar�application/vnd.oma-scws-config�application/vnd.oma-scws-http-request�application/vnd.oma-scws-http-response�application/vnd.oma.bcast.associated-procedure-parameter+xml�application/vnd.oma.bcast.drm-trigger+xml�application/vnd.oma.bcast.imd+xml�application/vnd.oma.bcast.ltkm�application/vnd.oma.bcast.notification+xml�application/vnd.oma.bcast.sgboot�application/vnd.oma.bcast.sgdd+xml�application/vnd.oma.bcast.sgdu�application/vnd.oma.bcast.simple-symbol-container�application/vnd.oma.bcast.smartcard-trigger+xml�application/vnd.oma.bcast.sprov+xml�application/vnd.oma.bcast.stkm�application/vnd.oma.dd2+xml�application/vnd.oma.drm.risd+xml�application/vnd.oma.group-usage-list+xml�application/vnd.oma.poc.detailed-progress-report+xml�application/vnd.oma.poc.final-report+xml�application/vnd.oma.poc.groups+xml�application/vnd.oma.poc.invocation-descriptor+xml�application/vnd.oma.poc.optimized-progress-report+xml�application/vnd.oma.xcap-directory+xml�application/vnd.omads-email+xml�application/vnd.omads-file+xml�application/vnd.omads-folder+xml�application/vnd.omaloc-supl-init�application/vnd.openofficeorg.extension�application/vnd.osa.netdeploy�application/vnd.osgi.bundle�application/vnd.osgi.dp�application/vnd.otps.ct-kip+xml�application/vnd.palm�application/vnd.paos.xml�application/vnd.pg.format�application/vnd.pg.osasli�application/vnd.piaccess.application-licence�application/vnd.picsel�application/vnd.poc.group-advertisement+xml�application/vnd.pocketlearn�application/vnd.powerbuilder6�application/vnd.powerbuilder6-s�application/vnd.powerbuilder7�application/vnd.powerbuilder7-s�application/vnd.powerbuilder75�application/vnd.powerbuilder75-s�application/vnd.preminet�application/vnd.previewsystems.box�application/vnd.proteus.magazine�application/vnd.publishare-delta-tree�application/vnd.pvi.ptid1�application/vnd.pwg-multiplexed�application/vnd.pwg-xhtml-print+xml�application/vnd.qualcomm.brew-app-res�application/vnd.rapid�application/vnd.recordare.musicxml�application/vnd.recordare.musicxml+xml�application/vnd.ruckus.download�application/vnd.s3sms�application/vnd.sbm.mid2�application/vnd.scribus�application/vnd.sealed.3df�application/vnd.sealed.csf�application/vnd.sealed.doc�application/vnd.sealed.eml�application/vnd.sealed.mht�application/vnd.sealed.net�application/vnd.sealed.ppt�application/vnd.sealed.tiff�application/vnd.sealed.xls�application/vnd.sealedmedia.softseal.html�application/vnd.sealedmedia.softseal.pdf�application/vnd.seemail�application/vnd.sema�application/vnd.semd�application/vnd.semf�application/vnd.shana.informed.formdata�application/vnd.shana.informed.formtemplate�application/vnd.shana.informed.interchange�application/vnd.shana.informed.package�application/vnd.smaf�application/vnd.solent.sdkm+xml�application/vnd.spotfire.dxp�application/vnd.spotfire.sfs�application/vnd.sss-cod�application/vnd.sss-dtf�application/vnd.sss-ntf�application/vnd.street-stream�application/vnd.sun.wadl+xml�application/vnd.sus-calendar�application/vnd.svd�application/vnd.swiftview-ics�application/vnd.syncml+xml�application/vnd.syncml.dm+wbxml�application/vnd.syncml.dm+xml�application/vnd.syncml.ds.notification�application/vnd.tao.intent-module-archive�application/vnd.tmobile-livetv�application/vnd.trid.tpt�application/vnd.triscape.mxs�application/vnd.trueapp�application/vnd.truedoc�application/vnd.ufdl�application/vnd.uiq.theme�application/vnd.umajin�application/vnd.unity�application/vnd.uoml+xml�application/vnd.uplanet.alert�application/vnd.uplanet.alert-wbxml�application/vnd.uplanet.bearer-choice�application/vnd.uplanet.bearer-choice-wbxml�application/vnd.uplanet.cacheop�application/vnd.uplanet.cacheop-wbxml�application/vnd.uplanet.channel�application/vnd.uplanet.channel-wbxml�application/vnd.uplanet.list�application/vnd.uplanet.list-wbxml�application/vnd.uplanet.listcmd�application/vnd.uplanet.listcmd-wbxml�application/vnd.uplanet.signal�application/vnd.vcx�application/vnd.vd-study�application/vnd.vectorworks�application/vnd.vidsoft.vidconference�application/vnd.visio�application/vnd.visionary�application/vnd.vividence.scriptfile�application/vnd.vsf�application/vnd.wap.sic�application/vnd.wap.slc�application/vnd.wap.wbxml�application/vnd.wap.wmlc�application/vnd.wap.wmlscriptc�application/vnd.webturbo�application/vnd.wfa.wsc�application/vnd.wmc�application/vnd.wmf.bootstrap�application/vnd.wordperfect�application/vnd.wqd�application/vnd.wrq-hp3000-labelled�application/vnd.wt.stf�application/vnd.wv.csp+wbxml�application/vnd.wv.csp+xml�application/vnd.wv.ssp+xml�application/vnd.xara�application/vnd.xfdl�application/vnd.xmpie.cpkg�application/vnd.xmpie.dpkg�application/vnd.xmpie.plan�application/vnd.xmpie.ppkg�application/vnd.xmpie.xlim�application/vnd.yamaha.hv-dic�application/vnd.yamaha.hv-script�application/vnd.yamaha.hv-voice�application/vnd.yamaha.smaf-audio�application/vnd.yamaha.smaf-phrase�application/vnd.yellowriver-custom-menu�application/vnd.zzazz.deck+xml�application/voicexml+xml�application/watcherinfo+xml�application/whoispp-query�application/whoispp-response�application/wita�application/wordperfect5.1�application/wsdl+xml�application/wspolicy+xml�application/x400-bp�application/xcap-att+xml�application/xcap-caps+xml�application/xcap-el+xml�application/xcap-error+xml�application/xcap-ns+xml�application/xenc+xml�application/xhtml+xml�application/xhtml-voice+xml (Obsolete)�application/xml�application/xml-dtd�application/xml-external-parsed-entity�application/xmpp+xml�application/xop+xml�application/xv+xml�application/zip�audio/32kadpcm�audio/3gpp�audio/3gpp2�audio/AMR�audio/AMR-WB�audio/BV16�audio/BV32�audio/CN�audio/DAT12�audio/DVI4�audio/EVRC�audio/EVRC-QCP�audio/EVRC0�audio/EVRC1�audio/EVRCB�audio/EVRCB0�audio/EVRCB1�audio/EVRCWB�audio/EVRCWB0�audio/EVRCWB1�audio/G722�audio/G7221�audio/G723�audio/G726-16�audio/G726-24�audio/G726-32�audio/G726-40�audio/G728�audio/G729�audio/G7291�audio/G729D�audio/G729E�audio/GSM�audio/GSM-EFR�audio/L16�audio/L20�audio/L24�audio/L8�audio/LPC�audio/MP4A-LATM�audio/MPA�audio/PCMA�audio/PCMU�audio/QCELP�audio/RED�audio/SMV�audio/SMV-QCP�audio/SMV0�audio/VDVI�audio/VMR-WB�audio/ac3�audio/amr-wb+�audio/asc�audio/basic�audio/clearmode�audio/dls�audio/dsr-es201108�audio/dsr-es202050�audio/dsr-es202211�audio/dsr-es202212�audio/eac3�audio/example�audio/iLBC�audio/mobile-xmf�audio/mp4�audio/mpa-robust�audio/mpeg�audio/mpeg4-generic�audio/parityfec�audio/prs.sid�audio/rRFC2045tp-midi�audio/rtp-enc-aescm128�audio/rtx�audio/sp-midi�audio/t140c�audio/t38�audio/telephone-event�audio/tone�audio/ulpfec�audio/vnd.3gpp.iufp�audio/vnd.4SB�audio/vnd.CELP�audio/vnd.audiokoz�audio/vnd.cisco.nse�audio/vnd.cmles.radio-events�audio/vnd.cns.anp1�audio/vnd.cns.inf1�audio/vnd.digital-winds�audio/vnd.dlna.adts�audio/vnd.dolby.mlp�audio/vnd.everad.plj�audio/vnd.hns.audio�audio/vnd.lucent.voice�audio/vnd.nokia.mobile-xmf�audio/vnd.nortel.vbk�audio/vnd.nuera.ecelp4800�audio/vnd.nuera.ecelp7470�audio/vnd.nuera.ecelp9600�audio/vnd.octel.sbc�audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp�audio/vnd.rhetorex.32kadpcm�audio/vnd.sealedmedia.softseal.mpeg�audio/vnd.vmx.cvsd�image/cgm�image/example�image/fits�image/g3fax�image/gif�image/ief�image/jp2�image/jpeg�image/jpm�image/jpx�image/naplps�image/png�image/prs.btif�image/prs.pti�image/t38�image/tiff�image/tiff-fx�image/vnd.adobe.photoshop�image/vnd.cns.inf2�image/vnd.djvu�image/vnd.dwg�image/vnd.dxf�image/vnd.fastbidsheet�image/vnd.fpx�image/vnd.fst�image/vnd.fujixerox.edmics-mmr�image/vnd.fujixerox.edmics-rlc�image/vnd.globalgraphics.pgb�image/vnd.microsoft.icon�image/vnd.mix�image/vnd.ms-modi�image/vnd.net-fpx�image/vnd.sealed.png�image/vnd.sealedmedia.softseal.gif�image/vnd.sealedmedia.softseal.jpg�image/vnd.svf�image/vnd.wap.wbmp�image/vnd.xiff�message/CPIM�message/delivery-status�message/disposition-notification�message/example�message/external-body�message/http�message/news�message/partial�message/rfc822�message/s-http�message/sip�message/sipfrag�message/tracking-status�message/vnd.si.simp�model/example�model/iges�model/mesh�model/vnd.dwf�model/vnd.flatland.3dml�model/vnd.gdl�model/vnd.gs-gdl�model/vnd.gtw�model/vnd.moml+xml�model/vnd.mts�model/vnd.parasolid.transmit.binary�model/vnd.parasolid.transmit.text�model/vnd.vtu�model/vrml�multipart/alternative�multipart/appledouble�multipart/byteranges�multipart/digest�multipart/encrypted�multipart/example�multipart/form-data�multipart/header-set�multipart/mixed�multipart/parallel�multipart/related�multipart/report�multipart/signed�multipart/voice-message�text/RED�text/calendar�text/css�text/csv�text/directory�text/dns�text/ecmascript (obsolete)�text/enriched�text/example�text/html�text/javascript (obsolete)�text/parityfec�text/plain�text/prs.fallenstein.rst�text/prs.lines.tag�text/rfc822-headers�text/richtext�text/rtf�text/rtp-enc-aescm128�text/rtx�text/sgml�text/t140�text/tab-separated-values�text/troff�text/ulpfec�text/uri-list�text/vnd.DMClientScript�text/vnd.IPTC.NITF�text/vnd.IPTC.NewsML�text/vnd.abc�text/vnd.curl�text/vnd.esmertec.theme-descriptor�text/vnd.fly�text/vnd.fmi.flexstor�text/vnd.in3d.3dml�text/vnd.in3d.spot�text/vnd.latex-z�text/vnd.motorola.reflex�text/vnd.ms-mediapackage�text/vnd.net2phone.commcenter.command�text/vnd.si.uricatalogue�text/vnd.sun.j2me.app-descriptor�text/vnd.trolltech.linguist�text/vnd.wap.si�text/vnd.wap.sl�text/vnd.wap.wml�text/vnd.wap.wmlscript�text/xml�text/xml-external-parsed-entity�video/3gpp�video/3gpp-tt�video/3gpp2�video/BMPEG�video/BT656�video/CelB�video/DV�video/H261�video/H263�video/H263-1998�video/H263-2000�video/H264�video/JPEG�video/MJ2�video/MP1S�video/MP2P�video/MP2T�video/MP4V-ES�video/MPV�video/SMPTE292M�video/example�video/mp4�video/mpeg�video/mpeg4-generic�video/nv�video/parityfec�video/pointer�video/quicktime�video/raw�video/rtp-enc-aescm128�video/rtx�video/ulpfec�video/vc1�video/vnd.dlna.mpeg-tts�video/vnd.fvt�video/vnd.hns.video�video/vnd.iptvforum.1dparityfec-1010�video/vnd.iptvforum.1dparityfec-2005�video/vnd.iptvforum.2dparityfec-1010�video/vnd.iptvforum.2dparityfec-2005�video/vnd.iptvforum.ttsavc�video/vnd.iptvforum.ttsmpeg2�video/vnd.motorola.video�video/vnd.motorola.videop�video/vnd.mpegurl�video/vnd.nokia.interleaved-multimedia�video/vnd.nokia.videovoip�video/vnd.objectvideo�video/vnd.sealed.mpeg1�video/vnd.sealed.mpeg4�video/vnd.sealed.swf�video/vnd.sealedmedia.softseal.mov�video/vnd.vivo�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-001]-Mime code in attribute MUST be MIMEMediaType.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:FinancialInstitution/cbc:ID//@schemeID" mode="w871aac13" priority="19">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:FinancialInstitution/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:FinancialInstitution/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:FinancialInstitution/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�BIC�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�BIC�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-002]-Financial Institution SHOULD be BIC code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PostalAddress/cbc:ID//@schemeID" mode="w871aac13" priority="18">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:PostalAddress/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PostalAddress/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PostalAddress/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GLN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GLN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-003]-Postal address identifiers SHOULD be GLN.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" mode="w871aac13" priority="17">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GLN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GLN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-004]-Location identifiers SHOULD be GLN</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" mode="w871aac13" priority="16">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�GTIN�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�GTIN�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-005]-Standard item identifiers SHOULD be GTIN.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" mode="w871aac13" priority="15">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�CPV�UNSPSC�eCLASS�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">contains('�CPV�UNSPSC�eCLASS�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cbc:TaxExemptionReasonCode" mode="w871aac13" priority="14">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cbc:TaxExemptionReasonCode" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:TaxExemptionReasonCode</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:TaxExemptionReasonCode</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AAA Exempt�AAB Exempt�AAC Exempt�AAE Reverse Charge�AAF Exempt�AAG Exempt�AAH Margin Scheme�AAI Margin Scheme�AAJ Reverse Charge�AAK Reverse Charge�AAL Reverse Charge Exempt�AAM Exempt New Means of Transport�AAN Exempt Triangulation�AAO Reverse Charge�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-007]-Tax exemption reasons MUST be coded using Use CWA 15577 tax exemption code list. Version 2006</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cac:PartyIdentification/cbc:ID//@schemeID" mode="w871aac13" priority="13">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cac:PartyIdentification/cbc:ID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PartyIdentification/cbc:ID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cac:PartyIdentification/cbc:ID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-008]-Party Identifiers MUST use the PEPPOL PartyID list</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="cbc:EndpointID//@schemeID" mode="w871aac13" priority="12">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac13']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <comment>WARNING: Rule for context "cbc:EndpointID//@schemeID" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:EndpointID//@schemeID</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac13">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">cbc:EndpointID//@schemeID</attribute>
          </ns1:fired-rule>
          <if test="not(contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�')))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">contains('�AD:VAT�AL:VAT�AT:CID�AT:GOV�AT:KUR�AT:VAT�BA:VAT�BE:VAT�BG:VAT�CH:VAT�CY:VAT�CZ:VAT�DE:VAT�DK:CPR�DK:CVR�DK:P�DK:SE�DK:VANS�DUNS�EE:VAT�ES:VAT�EU:REID�EU:VAT�FI:OVT�FR:SIRENE�FR:SIRET�GB:VAT�GLN�GR:VAT�HR:VAT�HU:VAT�IBAN�IE:VAT�IS:KT�IT:CF�IT:FTI�IT:IPA�IT:SECETI�IT:SIA�IT:VAT�LI:VAT�LT:VAT�LU:VAT�LV:VAT�MC:VAT�ME:VAT�MK:VAT�MT:VAT�NL:VAT�NO:ORGNR�NO:VAT�PL:VAT�PT:VAT�RO:VAT�RS:VAT�SE:ORGNR�SI:VAT�SK:VAT�SM:VAT�TR:VAT�VA:VAT�',concat('�',.,'�'))</attribute>
              <ns1:text>[PCL-015-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac13')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxCategory" mode="w871aac13" priority="11">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:TaxCategory" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxCategory</attribute>
          </ns1:fired-rule>
          <if test="not((parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')</attribute>
              <ns1:text>[EUGEN-T15-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AllowanceCharge" mode="w871aac13" priority="10">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:AllowanceCharge" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AllowanceCharge</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AllowanceCharge</attribute>
          </ns1:fired-rule>
          <if test="not((((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&quot;Invoice&quot;)) or not(local-name(parent:: node())=&quot;Invoice&quot;))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())="Invoice")) or not(local-name(parent:: node())="Invoice")</attribute>
              <ns1:text>[EUGEN-T15-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(cbc:Amount)>=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:Amount)&gt;=0</attribute>
              <ns1:text>[EUGEN-T15-R022]-An allowance or charge amount MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:AllowanceChargeReason))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:AllowanceChargeReason)</attribute>
              <ns1:text>[EUGEN-T15-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(number(cbc:MultiplierFactorNumeric) >=0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:MultiplierFactorNumeric) &gt;=0</attribute>
              <ns1:text>[EUGEN-T15-R012]-An allowance percentage MUST NOT be negative.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))</attribute>
              <ns1:text>[EUGEN-T15-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingCustomerParty/cac:Party" mode="w871aac13" priority="9">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:AccountingCustomerParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingCustomerParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T15-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:LegalMonetaryTotal" mode="w871aac13" priority="8">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:LegalMonetaryTotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:LegalMonetaryTotal</attribute>
          </ns1:fired-rule>
          <if test="not(number(cbc:PayableAmount) >= 0)">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">number(cbc:PayableAmount) &gt;= 0</attribute>
              <ns1:text>[EUGEN-T15-R019]-Total payable amount in an invoice MUST NOT be negative</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Delivery/cac:DeliveryLocation/cac:Address" mode="w871aac13" priority="7">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:Delivery/cac:DeliveryLocation/cac:Address" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Delivery/cac:DeliveryLocation/cac:Address</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Delivery/cac:DeliveryLocation/cac:Address</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T15-R005]-A Delivery address in an SHOULD contain at least, city, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:AccountingSupplierParty/cac:Party" mode="w871aac13" priority="6">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:AccountingSupplierParty/cac:Party" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:AccountingSupplierParty/cac:Party</attribute>
          </ns1:fired-rule>
          <if test="not((cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)</attribute>
              <ns1:text>[EUGEN-T15-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="/ubl:Invoice" mode="w871aac13" priority="5">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "/ubl:Invoice" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">/ubl:Invoice</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))</attribute>
              <ns1:text>[EUGEN-T15-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)</attribute>
              <ns1:text>[EUGEN-T15-R010]-If payee information is provided then the payee name MUST be specified.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T15-R015]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)</attribute>
              <ns1:text>[EUGEN-T15-R016]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T15-R017]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not ((//cac:TaxCategory/cbc:ID) = 'AE')</attribute>
              <ns1:text>[EUGEN-T15-R018]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not(not(//@currencyID != //cbc:DocumentCurrencyCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">not(//@currencyID != //cbc:DocumentCurrencyCode)</attribute>
              <ns1:text>[EUGEN-T15-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoicePeriod" mode="w871aac13" priority="4">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:InvoicePeriod" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoicePeriod</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:StartDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:StartDate)</attribute>
              <ns1:text>[EUGEN-T15-R020]-If the invoice refers to a period, the period MUST have an start date.</ns1:text>
            </ns1:failed-assert>
          </if>
          <if test="not((cbc:EndDate))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:EndDate)</attribute>
              <ns1:text>[EUGEN-T15-R021]-If the invoice refers to a period, the period MUST have an end date.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:PaymentMeans" mode="w871aac13" priority="3">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:PaymentMeans" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:PaymentMeans</attribute>
          </ns1:fired-rule>
          <if test="not(((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN'))))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))</attribute>
              <ns1:text>[EUGEN-T15-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:Item/cac:ClassifiedTaxCategory" mode="w871aac13" priority="2">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:Item/cac:ClassifiedTaxCategory" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item/cac:ClassifiedTaxCategory</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:Item/cac:ClassifiedTaxCategory</attribute>
          </ns1:fired-rule>
          <if test="not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="fatal" location="{schxslt:location(.)}">
              <attribute name="test">(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))</attribute>
              <ns1:text>[EUGEN-T15-R011]-If the VAT total amount in an invoice exists then each invoice line item must have a VAT category ID.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:InvoiceLine" mode="w871aac13" priority="1">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:InvoiceLine" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:InvoiceLine</attribute>
          </ns1:fired-rule>
          <if test="not((cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)</attribute>
              <ns1:text>[EUGEN-T15-R003]-Each invoice line SHOULD contain the quantity and unit of measure</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <template match="//cac:TaxSubtotal" mode="w871aac13" priority="0">
    <param as="xs:string*" name="schxslt:patterns-matched" />
    <choose>
      <when test="$schxslt:patterns-matched[. = 'w871aac15']">
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <comment>WARNING: Rule for context "//cac:TaxSubtotal" shadowed by preceding rule</comment>
          <ns1:suppressed-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxSubtotal</attribute>
          </ns1:suppressed-rule>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="$schxslt:patterns-matched" />
        </next-match>
      </when>
      <otherwise>
        <ns0:rule xmlns:ns0="https://doi.org/10.5281/zenodo.1495494" pattern="w871aac15">
          <ns1:fired-rule xmlns:ns1="http://purl.oclc.org/dsdl/svrl">
            <attribute name="context">//cac:TaxSubtotal</attribute>
          </ns1:fired-rule>
          <if test="not(((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != 'E'))">
            <ns1:failed-assert xmlns:ns1="http://purl.oclc.org/dsdl/svrl" flag="warning" location="{schxslt:location(.)}">
              <attribute name="test">((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or  (cac:TaxCategory/cbc:ID != 'E')</attribute>
              <ns1:text>[EUGEN-T15-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</ns1:text>
            </ns1:failed-assert>
          </if>
        </ns0:rule>
        <next-match>
          <with-param as="xs:string*" name="schxslt:patterns-matched" select="($schxslt:patterns-matched, 'w871aac15')" />
        </next-match>
      </otherwise>
    </choose>
  </template>
  <function as="xs:string" name="schxslt:location">
    <param as="node()" name="node" />
    <variable as="xs:string*" name="segments">
      <for-each select="($node/ancestor-or-self::node())">
        <variable name="position">
          <number level="single" />
        </variable>
        <choose>
          <when test=". instance of element()">
            <value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')" />
          </when>
          <when test=". instance of attribute()">
            <value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))" />
          </when>
          <when test=". instance of processing-instruction()">
            <value-of select="concat('processing-instruction(&quot;', name(.), '&quot;)[', $position, ']')" />
          </when>
          <when test=". instance of comment()">
            <value-of select="concat('comment()[', $position, ']')" />
          </when>
          <when test=". instance of text()">
            <value-of select="concat('text()[', $position, ']')" />
          </when>
          <otherwise />
        </choose>
      </for-each>
    </variable>
    <value-of select="concat('/', string-join($segments, '/'))" />
  </function>
</transform>
