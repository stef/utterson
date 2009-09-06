# -*- make -*-
# FILE: "blog/Makefile"
# (C) 2009 by Stefan Marsiske, <stefan.marsiske@gmail.com>
# $Id:$

maxposts=15
TMPDIR=tmp
SHELL:=/usr/bin/zsh
allposts:=$(shell ls -t posts/*.html )
newestposts:=$(shell ls -t posts/*.html | head -$(maxposts) )

# move all files afterwards to www

all: posts archive atom sitemap static

index: $(TMPDIR)/index.html
atom: $(TMPDIR)/atom.xml
sitemap: $(TMPDIR)/sitemap.xml.gz

$(TMPDIR)/index.html: $(newestposts)
	ksh bin/index $^ >$@

$(TMPDIR)/atom.xml: $(newestposts)
	ksh bin/atom $^ >$@

static: layout/static/*
	ksh bin/static $^

Makefile: $(allposts)
	cp Makefile.in Makefile
#	create page rules
	set -A allposts $^; \
   pagecnt=$$(($${#allposts[@]} / $(maxposts) )); \
   i=1; \
   while [ $$i -lt $${pagecnt} ]; do \
       lbound=$$((i*$(maxposts) +1)); \
       ubound=$$((i*$(maxposts) +$(maxposts) )); \
       next=$$((i+1)); \
       if [ $$next -lt $$pagecnt ]; then \
           nextpage="page-$$next.html"; \
       else \
           nextpage=""; \
       fi; \
       prev=$$((i-1)); \
       if [ $$prev -eq 0 ]; then \
           prevpage="index.html"; \
       else \
           prevpage="page-$$prev.html"; \
       fi; \
       pages="$$pages \$$(TMPDIR)/page-$$i.html"; \
       echo "\$$(TMPDIR)/page-$$i.html: $${allposts[$$lbound,$$ubound]}" >>$@; \
       echo "	ksh bin/page \"page-$$i.html\" \"$$prevpage\" \"$$nextpage\" "'$$^'" >\$$@" >>$@; \
       echo >>$@; \
   	 i=$$((i + 1)); \
   done; \
   echo "pages: $$pages" >>$@; \
   echo >>$@; \
   echo "archive: \$$(TMPDIR)/index.html $$pages" >>$@; \
   echo >>$@; \
   echo "\$$(TMPDIR)/sitemap.xml.gz: "'$$'"(allposts) \$$(TMPDIR)/index.html $$pages" >>$@; \
   echo "	ksh bin/sitemap "'$$'"(allposts) | gzip -c >tmp/sitemap.xml.gz" >>$@; \
echo >>$@
#	create posts rules
	i=1; \
	set -A files $^; \
	while [ $${#files[@]} -ge $$i ]; do \
		echo "\$$(TMPDIR)/$${files[i]}: $${files[i]}" >>$@; \
      echo "	@test -d \$$(@D) || mkdir -p \$$(@D)" >>$@; \
		echo "	ksh bin/post \"$${files[i]}\" \"$${files[i-1]}\" \"$${files[i+1]}\" >\$$@\n\n" >>"$@"; \
		postpages="$$postpages \$$(TMPDIR)/$${files[i]}"; \
		i=$$((i+1)); \
	done; \
	echo "posts: $$postpages" >>$@

clean:
	rm $(TMPDIR)/*.(html|xml|gz|css)
	rm -rf $(TMPDIR)/posts

.PHONY: index posts static
$(TMPDIR)/page-1.html: posts/morzsalék.html posts/linxutag2009_külügyes_slide.html posts/hírcsokor.html posts/Kedvenc_Monopóliumunk.html posts/Manifesztó.html posts/Anti-Pató_Pál_Manifesztó.html posts/Greenspan_rendszerváltásról.html posts/geo_hírek.html posts/hírmorzsák.html posts/Europe_sponsored_by_Intel.html posts/monstre_hírcsokor_a_digitális_világból.html posts/tv_helyett.html posts/Dieter_Bohlen_ex_Modern_Talking.html posts/így_kell_szabványokat_írni.html posts/EU_vs_privacy.html
	ksh bin/page "page-1.html" "index.html" "page-2.html" $^ >$@

$(TMPDIR)/page-2.html: posts/Szabad_Szoftverek_Magyarországon.html posts/EU_Telecom_csomag_ügyben.html posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html posts/RMS_in_Budapest.html posts/timing.html posts/timecloud_v1.2.html posts/jquery_slider_woes.html posts/ügyfélkapu_incidens.html posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html posts/firefox_kiegészítőim.html posts/timecloud__jquery_1.3.1.html posts/elolvasni.html posts/swpat_barométer.html posts/tudásipar.html posts/hamis_pozitív.html
	ksh bin/page "page-2.html" "page-1.html" "page-3.html" $^ >$@

$(TMPDIR)/page-3.html: posts/hackerspace_levlista.html posts/hackerspace-t_magunknak!.html posts/Szellemjog.html posts/és_gyorsan_még_egy_aláírásgyűjtés.html posts/sw_szabadalmak_ügyében.html posts/tanulságos.html posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html posts/25c3_-_a_quick_summary.html posts/HNY_-_BUÉK!!!.html posts/Timecloud_v1.1.1.html posts/Nyílt_hálózatok.html posts/JQuery_Timecloud_v1.0.html posts/Kultúra-ipar.html posts/A_free_szó_etimológiája.html posts/nagytakarítás.html
	ksh bin/page "page-3.html" "page-2.html" "page-4.html" $^ >$@

$(TMPDIR)/page-4.html: posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html posts/grindr.html posts/frekvencia.html posts/pályázatok_és_nagy_dolgok....html posts/könyvajánló_Emergence,_from_chaos_to_order.html posts/mi_ez_a_nagy_csend?.html posts/innováció-történelem_68.html posts/Kultúra_vs_kommersz.html posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html posts/Open_Standards_Alliance.html posts/mobil_telefonok_szabadon.html posts/szabadszoftver_felhasznalasban_jok_vagyunk.html posts/Haptic_feedback_hatodik_érzék.html posts/wshare_-_sharing_the_internet_over_wifi.html posts/oblig_First_POST!_.html
	ksh bin/page "page-4.html" "page-3.html" "" $^ >$@

pages:  $(TMPDIR)/page-1.html $(TMPDIR)/page-2.html $(TMPDIR)/page-3.html $(TMPDIR)/page-4.html

archive: $(TMPDIR)/index.html  $(TMPDIR)/page-1.html $(TMPDIR)/page-2.html $(TMPDIR)/page-3.html $(TMPDIR)/page-4.html

$(TMPDIR)/sitemap.xml.gz: $(allposts) $(TMPDIR)/index.html  $(TMPDIR)/page-1.html $(TMPDIR)/page-2.html $(TMPDIR)/page-3.html $(TMPDIR)/page-4.html
	ksh bin/sitemap $(allposts) | gzip -c >tmp/sitemap.xml.gz

$(TMPDIR)/posts/nekem_a_Skype_gyanús.html: posts/nekem_a_Skype_gyanús.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/nekem_a_Skype_gyanús.html" "" "posts/HAR_Szabad_GSM.html" >$@


$(TMPDIR)/posts/HAR_Szabad_GSM.html: posts/HAR_Szabad_GSM.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/HAR_Szabad_GSM.html" "posts/nekem_a_Skype_gyanús.html" "posts/nyárvégi_morzsák.html" >$@


$(TMPDIR)/posts/nyárvégi_morzsák.html: posts/nyárvégi_morzsák.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/nyárvégi_morzsák.html" "posts/HAR_Szabad_GSM.html" "posts/waddenzen.html" >$@


$(TMPDIR)/posts/waddenzen.html: posts/waddenzen.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/waddenzen.html" "posts/nyárvégi_morzsák.html" "posts/Megint_Reding_a_web2.0-ról.html" >$@


$(TMPDIR)/posts/Megint_Reding_a_web2.0-ról.html: posts/Megint_Reding_a_web2.0-ról.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Megint_Reding_a_web2.0-ról.html" "posts/waddenzen.html" "posts/net_cenzúra.html" >$@


$(TMPDIR)/posts/net_cenzúra.html: posts/net_cenzúra.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/net_cenzúra.html" "posts/Megint_Reding_a_web2.0-ról.html" "posts/fnordok.html" >$@


$(TMPDIR)/posts/fnordok.html: posts/fnordok.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/fnordok.html" "posts/net_cenzúra.html" "posts/linuxtag_-_német_külügyesek.html" >$@


$(TMPDIR)/posts/linuxtag_-_német_külügyesek.html: posts/linuxtag_-_német_külügyesek.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linuxtag_-_német_külügyesek.html" "posts/fnordok.html" "posts/linuxtag_-_migrációk.html" >$@


$(TMPDIR)/posts/linuxtag_-_migrációk.html: posts/linuxtag_-_migrációk.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linuxtag_-_migrációk.html" "posts/linuxtag_-_német_külügyesek.html" "posts/Reding_a_fájlcserélésről.html" >$@


$(TMPDIR)/posts/Reding_a_fájlcserélésről.html: posts/Reding_a_fájlcserélésről.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Reding_a_fájlcserélésről.html" "posts/linuxtag_-_migrációk.html" "posts/Megújult_a_tvhelyett.html" >$@


$(TMPDIR)/posts/Megújult_a_tvhelyett.html: posts/Megújult_a_tvhelyett.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Megújult_a_tvhelyett.html" "posts/Reding_a_fájlcserélésről.html" "posts/linuxtag_-_szabadalmak.html" >$@


$(TMPDIR)/posts/linuxtag_-_szabadalmak.html: posts/linuxtag_-_szabadalmak.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linuxtag_-_szabadalmak.html" "posts/Megújult_a_tvhelyett.html" "posts/linuxtag_-_pólók.html" >$@


$(TMPDIR)/posts/linuxtag_-_pólók.html: posts/linuxtag_-_pólók.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linuxtag_-_pólók.html" "posts/linuxtag_-_szabadalmak.html" "posts/linuxtag_-_wrap-up.html" >$@


$(TMPDIR)/posts/linuxtag_-_wrap-up.html: posts/linuxtag_-_wrap-up.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linuxtag_-_wrap-up.html" "posts/linuxtag_-_pólók.html" "posts/kalózok.html" >$@


$(TMPDIR)/posts/kalózok.html: posts/kalózok.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/kalózok.html" "posts/linuxtag_-_wrap-up.html" "posts/morzsalék.html" >$@


$(TMPDIR)/posts/morzsalék.html: posts/morzsalék.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/morzsalék.html" "posts/kalózok.html" "posts/linxutag2009_külügyes_slide.html" >$@


$(TMPDIR)/posts/linxutag2009_külügyes_slide.html: posts/linxutag2009_külügyes_slide.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/linxutag2009_külügyes_slide.html" "posts/morzsalék.html" "posts/hírcsokor.html" >$@


$(TMPDIR)/posts/hírcsokor.html: posts/hírcsokor.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/hírcsokor.html" "posts/linxutag2009_külügyes_slide.html" "posts/Kedvenc_Monopóliumunk.html" >$@


$(TMPDIR)/posts/Kedvenc_Monopóliumunk.html: posts/Kedvenc_Monopóliumunk.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Kedvenc_Monopóliumunk.html" "posts/hírcsokor.html" "posts/Manifesztó.html" >$@


$(TMPDIR)/posts/Manifesztó.html: posts/Manifesztó.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Manifesztó.html" "posts/Kedvenc_Monopóliumunk.html" "posts/Anti-Pató_Pál_Manifesztó.html" >$@


$(TMPDIR)/posts/Anti-Pató_Pál_Manifesztó.html: posts/Anti-Pató_Pál_Manifesztó.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Anti-Pató_Pál_Manifesztó.html" "posts/Manifesztó.html" "posts/Greenspan_rendszerváltásról.html" >$@


$(TMPDIR)/posts/Greenspan_rendszerváltásról.html: posts/Greenspan_rendszerváltásról.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Greenspan_rendszerváltásról.html" "posts/Anti-Pató_Pál_Manifesztó.html" "posts/geo_hírek.html" >$@


$(TMPDIR)/posts/geo_hírek.html: posts/geo_hírek.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/geo_hírek.html" "posts/Greenspan_rendszerváltásról.html" "posts/hírmorzsák.html" >$@


$(TMPDIR)/posts/hírmorzsák.html: posts/hírmorzsák.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/hírmorzsák.html" "posts/geo_hírek.html" "posts/Europe_sponsored_by_Intel.html" >$@


$(TMPDIR)/posts/Europe_sponsored_by_Intel.html: posts/Europe_sponsored_by_Intel.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Europe_sponsored_by_Intel.html" "posts/hírmorzsák.html" "posts/monstre_hírcsokor_a_digitális_világból.html" >$@


$(TMPDIR)/posts/monstre_hírcsokor_a_digitális_világból.html: posts/monstre_hírcsokor_a_digitális_világból.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/monstre_hírcsokor_a_digitális_világból.html" "posts/Europe_sponsored_by_Intel.html" "posts/tv_helyett.html" >$@


$(TMPDIR)/posts/tv_helyett.html: posts/tv_helyett.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/tv_helyett.html" "posts/monstre_hírcsokor_a_digitális_világból.html" "posts/Dieter_Bohlen_ex_Modern_Talking.html" >$@


$(TMPDIR)/posts/Dieter_Bohlen_ex_Modern_Talking.html: posts/Dieter_Bohlen_ex_Modern_Talking.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Dieter_Bohlen_ex_Modern_Talking.html" "posts/tv_helyett.html" "posts/így_kell_szabványokat_írni.html" >$@


$(TMPDIR)/posts/így_kell_szabványokat_írni.html: posts/így_kell_szabványokat_írni.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/így_kell_szabványokat_írni.html" "posts/Dieter_Bohlen_ex_Modern_Talking.html" "posts/EU_vs_privacy.html" >$@


$(TMPDIR)/posts/EU_vs_privacy.html: posts/EU_vs_privacy.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/EU_vs_privacy.html" "posts/így_kell_szabványokat_írni.html" "posts/Szabad_Szoftverek_Magyarországon.html" >$@


$(TMPDIR)/posts/Szabad_Szoftverek_Magyarországon.html: posts/Szabad_Szoftverek_Magyarországon.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Szabad_Szoftverek_Magyarországon.html" "posts/EU_vs_privacy.html" "posts/EU_Telecom_csomag_ügyben.html" >$@


$(TMPDIR)/posts/EU_Telecom_csomag_ügyben.html: posts/EU_Telecom_csomag_ügyben.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/EU_Telecom_csomag_ügyben.html" "posts/Szabad_Szoftverek_Magyarországon.html" "posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html" >$@


$(TMPDIR)/posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html: posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html" "posts/EU_Telecom_csomag_ügyben.html" "posts/RMS_in_Budapest.html" >$@


$(TMPDIR)/posts/RMS_in_Budapest.html: posts/RMS_in_Budapest.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/RMS_in_Budapest.html" "posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html" "posts/timing.html" >$@


$(TMPDIR)/posts/timing.html: posts/timing.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/timing.html" "posts/RMS_in_Budapest.html" "posts/timecloud_v1.2.html" >$@


$(TMPDIR)/posts/timecloud_v1.2.html: posts/timecloud_v1.2.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/timecloud_v1.2.html" "posts/timing.html" "posts/jquery_slider_woes.html" >$@


$(TMPDIR)/posts/jquery_slider_woes.html: posts/jquery_slider_woes.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/jquery_slider_woes.html" "posts/timecloud_v1.2.html" "posts/ügyfélkapu_incidens.html" >$@


$(TMPDIR)/posts/ügyfélkapu_incidens.html: posts/ügyfélkapu_incidens.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/ügyfélkapu_incidens.html" "posts/jquery_slider_woes.html" "posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html" >$@


$(TMPDIR)/posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html: posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html" "posts/ügyfélkapu_incidens.html" "posts/firefox_kiegészítőim.html" >$@


$(TMPDIR)/posts/firefox_kiegészítőim.html: posts/firefox_kiegészítőim.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/firefox_kiegészítőim.html" "posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html" "posts/timecloud__jquery_1.3.1.html" >$@


$(TMPDIR)/posts/timecloud__jquery_1.3.1.html: posts/timecloud__jquery_1.3.1.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/timecloud__jquery_1.3.1.html" "posts/firefox_kiegészítőim.html" "posts/elolvasni.html" >$@


$(TMPDIR)/posts/elolvasni.html: posts/elolvasni.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/elolvasni.html" "posts/timecloud__jquery_1.3.1.html" "posts/swpat_barométer.html" >$@


$(TMPDIR)/posts/swpat_barométer.html: posts/swpat_barométer.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/swpat_barométer.html" "posts/elolvasni.html" "posts/tudásipar.html" >$@


$(TMPDIR)/posts/tudásipar.html: posts/tudásipar.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/tudásipar.html" "posts/swpat_barométer.html" "posts/hamis_pozitív.html" >$@


$(TMPDIR)/posts/hamis_pozitív.html: posts/hamis_pozitív.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/hamis_pozitív.html" "posts/tudásipar.html" "posts/hackerspace_levlista.html" >$@


$(TMPDIR)/posts/hackerspace_levlista.html: posts/hackerspace_levlista.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/hackerspace_levlista.html" "posts/hamis_pozitív.html" "posts/hackerspace-t_magunknak!.html" >$@


$(TMPDIR)/posts/hackerspace-t_magunknak!.html: posts/hackerspace-t_magunknak!.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/hackerspace-t_magunknak!.html" "posts/hackerspace_levlista.html" "posts/Szellemjog.html" >$@


$(TMPDIR)/posts/Szellemjog.html: posts/Szellemjog.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Szellemjog.html" "posts/hackerspace-t_magunknak!.html" "posts/és_gyorsan_még_egy_aláírásgyűjtés.html" >$@


$(TMPDIR)/posts/és_gyorsan_még_egy_aláírásgyűjtés.html: posts/és_gyorsan_még_egy_aláírásgyűjtés.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/és_gyorsan_még_egy_aláírásgyűjtés.html" "posts/Szellemjog.html" "posts/sw_szabadalmak_ügyében.html" >$@


$(TMPDIR)/posts/sw_szabadalmak_ügyében.html: posts/sw_szabadalmak_ügyében.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/sw_szabadalmak_ügyében.html" "posts/és_gyorsan_még_egy_aláírásgyűjtés.html" "posts/tanulságos.html" >$@


$(TMPDIR)/posts/tanulságos.html: posts/tanulságos.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/tanulságos.html" "posts/sw_szabadalmak_ügyében.html" "posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html" >$@


$(TMPDIR)/posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html: posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html" "posts/tanulságos.html" "posts/25c3_-_a_quick_summary.html" >$@


$(TMPDIR)/posts/25c3_-_a_quick_summary.html: posts/25c3_-_a_quick_summary.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/25c3_-_a_quick_summary.html" "posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html" "posts/HNY_-_BUÉK!!!.html" >$@


$(TMPDIR)/posts/HNY_-_BUÉK!!!.html: posts/HNY_-_BUÉK!!!.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/HNY_-_BUÉK!!!.html" "posts/25c3_-_a_quick_summary.html" "posts/Timecloud_v1.1.1.html" >$@


$(TMPDIR)/posts/Timecloud_v1.1.1.html: posts/Timecloud_v1.1.1.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Timecloud_v1.1.1.html" "posts/HNY_-_BUÉK!!!.html" "posts/Nyílt_hálózatok.html" >$@


$(TMPDIR)/posts/Nyílt_hálózatok.html: posts/Nyílt_hálózatok.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Nyílt_hálózatok.html" "posts/Timecloud_v1.1.1.html" "posts/JQuery_Timecloud_v1.0.html" >$@


$(TMPDIR)/posts/JQuery_Timecloud_v1.0.html: posts/JQuery_Timecloud_v1.0.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/JQuery_Timecloud_v1.0.html" "posts/Nyílt_hálózatok.html" "posts/Kultúra-ipar.html" >$@


$(TMPDIR)/posts/Kultúra-ipar.html: posts/Kultúra-ipar.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Kultúra-ipar.html" "posts/JQuery_Timecloud_v1.0.html" "posts/A_free_szó_etimológiája.html" >$@


$(TMPDIR)/posts/A_free_szó_etimológiája.html: posts/A_free_szó_etimológiája.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/A_free_szó_etimológiája.html" "posts/Kultúra-ipar.html" "posts/nagytakarítás.html" >$@


$(TMPDIR)/posts/nagytakarítás.html: posts/nagytakarítás.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/nagytakarítás.html" "posts/A_free_szó_etimológiája.html" "posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html" >$@


$(TMPDIR)/posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html: posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html" "posts/nagytakarítás.html" "posts/grindr.html" >$@


$(TMPDIR)/posts/grindr.html: posts/grindr.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/grindr.html" "posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html" "posts/frekvencia.html" >$@


$(TMPDIR)/posts/frekvencia.html: posts/frekvencia.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/frekvencia.html" "posts/grindr.html" "posts/pályázatok_és_nagy_dolgok....html" >$@


$(TMPDIR)/posts/pályázatok_és_nagy_dolgok....html: posts/pályázatok_és_nagy_dolgok....html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/pályázatok_és_nagy_dolgok....html" "posts/frekvencia.html" "posts/könyvajánló_Emergence,_from_chaos_to_order.html" >$@


$(TMPDIR)/posts/könyvajánló_Emergence,_from_chaos_to_order.html: posts/könyvajánló_Emergence,_from_chaos_to_order.html
	@test -d $(@D) || mkdir -p $(@D)
	noglob ksh bin/post "posts/könyvajánló_Emergence,_from_chaos_to_order.html" "posts/pályázatok_és_nagy_dolgok....html" "posts/mi_ez_a_nagy_csend?.html" >$@


$(TMPDIR)/posts/mi_ez_a_nagy_csend?.html: posts/mi_ez_a_nagy_csend?.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/mi_ez_a_nagy_csend?.html" "posts/könyvajánló_Emergence,_from_chaos_to_order.html" "posts/innováció-történelem_68.html" >$@


$(TMPDIR)/posts/innováció-történelem_68.html: posts/innováció-történelem_68.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/innováció-történelem_68.html" "posts/mi_ez_a_nagy_csend?.html" "posts/Kultúra_vs_kommersz.html" >$@


$(TMPDIR)/posts/Kultúra_vs_kommersz.html: posts/Kultúra_vs_kommersz.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Kultúra_vs_kommersz.html" "posts/innováció-történelem_68.html" "posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html" >$@


$(TMPDIR)/posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html: posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html" "posts/Kultúra_vs_kommersz.html" "posts/Open_Standards_Alliance.html" >$@


$(TMPDIR)/posts/Open_Standards_Alliance.html: posts/Open_Standards_Alliance.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Open_Standards_Alliance.html" "posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html" "posts/mobil_telefonok_szabadon.html" >$@


$(TMPDIR)/posts/mobil_telefonok_szabadon.html: posts/mobil_telefonok_szabadon.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/mobil_telefonok_szabadon.html" "posts/Open_Standards_Alliance.html" "posts/szabadszoftver_felhasznalasban_jok_vagyunk.html" >$@


$(TMPDIR)/posts/szabadszoftver_felhasznalasban_jok_vagyunk.html: posts/szabadszoftver_felhasznalasban_jok_vagyunk.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/szabadszoftver_felhasznalasban_jok_vagyunk.html" "posts/mobil_telefonok_szabadon.html" "posts/Haptic_feedback_hatodik_érzék.html" >$@


$(TMPDIR)/posts/Haptic_feedback_hatodik_érzék.html: posts/Haptic_feedback_hatodik_érzék.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/Haptic_feedback_hatodik_érzék.html" "posts/szabadszoftver_felhasznalasban_jok_vagyunk.html" "posts/wshare_-_sharing_the_internet_over_wifi.html" >$@


$(TMPDIR)/posts/wshare_-_sharing_the_internet_over_wifi.html: posts/wshare_-_sharing_the_internet_over_wifi.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/wshare_-_sharing_the_internet_over_wifi.html" "posts/Haptic_feedback_hatodik_érzék.html" "posts/oblig_First_POST!_.html" >$@


$(TMPDIR)/posts/oblig_First_POST!_.html: posts/oblig_First_POST!_.html
	@test -d $(@D) || mkdir -p $(@D)
	ksh bin/post "posts/oblig_First_POST!_.html" "posts/wshare_-_sharing_the_internet_over_wifi.html" "" >$@


posts:  $(TMPDIR)/posts/nekem_a_Skype_gyanús.html $(TMPDIR)/posts/HAR_Szabad_GSM.html $(TMPDIR)/posts/nyárvégi_morzsák.html $(TMPDIR)/posts/waddenzen.html $(TMPDIR)/posts/Megint_Reding_a_web2.0-ról.html $(TMPDIR)/posts/net_cenzúra.html $(TMPDIR)/posts/fnordok.html $(TMPDIR)/posts/linuxtag_-_német_külügyesek.html $(TMPDIR)/posts/linuxtag_-_migrációk.html $(TMPDIR)/posts/Reding_a_fájlcserélésről.html $(TMPDIR)/posts/Megújult_a_tvhelyett.html $(TMPDIR)/posts/linuxtag_-_szabadalmak.html $(TMPDIR)/posts/linuxtag_-_pólók.html $(TMPDIR)/posts/linuxtag_-_wrap-up.html $(TMPDIR)/posts/kalózok.html $(TMPDIR)/posts/morzsalék.html $(TMPDIR)/posts/linxutag2009_külügyes_slide.html $(TMPDIR)/posts/hírcsokor.html $(TMPDIR)/posts/Kedvenc_Monopóliumunk.html $(TMPDIR)/posts/Manifesztó.html $(TMPDIR)/posts/Anti-Pató_Pál_Manifesztó.html $(TMPDIR)/posts/Greenspan_rendszerváltásról.html $(TMPDIR)/posts/geo_hírek.html $(TMPDIR)/posts/hírmorzsák.html $(TMPDIR)/posts/Europe_sponsored_by_Intel.html $(TMPDIR)/posts/monstre_hírcsokor_a_digitális_világból.html $(TMPDIR)/posts/tv_helyett.html $(TMPDIR)/posts/Dieter_Bohlen_ex_Modern_Talking.html $(TMPDIR)/posts/így_kell_szabványokat_írni.html $(TMPDIR)/posts/EU_vs_privacy.html $(TMPDIR)/posts/Szabad_Szoftverek_Magyarországon.html $(TMPDIR)/posts/EU_Telecom_csomag_ügyben.html $(TMPDIR)/posts/Richard_M_Stallman_rms_in_Budapest_-_zanza.html $(TMPDIR)/posts/RMS_in_Budapest.html $(TMPDIR)/posts/timing.html $(TMPDIR)/posts/timecloud_v1.2.html $(TMPDIR)/posts/jquery_slider_woes.html $(TMPDIR)/posts/ügyfélkapu_incidens.html $(TMPDIR)/posts/az_EU_meghosszabbította_a_szerzői_jogot_95_évre.html $(TMPDIR)/posts/firefox_kiegészítőim.html $(TMPDIR)/posts/timecloud__jquery_1.3.1.html $(TMPDIR)/posts/elolvasni.html $(TMPDIR)/posts/swpat_barométer.html $(TMPDIR)/posts/tudásipar.html $(TMPDIR)/posts/hamis_pozitív.html $(TMPDIR)/posts/hackerspace_levlista.html $(TMPDIR)/posts/hackerspace-t_magunknak!.html $(TMPDIR)/posts/Szellemjog.html $(TMPDIR)/posts/és_gyorsan_még_egy_aláírásgyűjtés.html $(TMPDIR)/posts/sw_szabadalmak_ügyében.html $(TMPDIR)/posts/tanulságos.html $(TMPDIR)/posts/Szabadon_letölthető_album_az_amazon-on_kaszált.html $(TMPDIR)/posts/25c3_-_a_quick_summary.html $(TMPDIR)/posts/HNY_-_BUÉK!!!.html $(TMPDIR)/posts/Timecloud_v1.1.1.html $(TMPDIR)/posts/Nyílt_hálózatok.html $(TMPDIR)/posts/JQuery_Timecloud_v1.0.html $(TMPDIR)/posts/Kultúra-ipar.html $(TMPDIR)/posts/A_free_szó_etimológiája.html $(TMPDIR)/posts/nagytakarítás.html $(TMPDIR)/posts/Ami_elkerülte_a_hírszerkesztők_figyelmét.html $(TMPDIR)/posts/grindr.html $(TMPDIR)/posts/frekvencia.html $(TMPDIR)/posts/pályázatok_és_nagy_dolgok....html $(TMPDIR)/posts/könyvajánló_Emergence,_from_chaos_to_order.html $(TMPDIR)/posts/mi_ez_a_nagy_csend?.html $(TMPDIR)/posts/innováció-történelem_68.html $(TMPDIR)/posts/Kultúra_vs_kommersz.html $(TMPDIR)/posts/Hétfőn_döntenek_a_francia_3vétség_EUs_bevezetéséről.html $(TMPDIR)/posts/Open_Standards_Alliance.html $(TMPDIR)/posts/mobil_telefonok_szabadon.html $(TMPDIR)/posts/szabadszoftver_felhasznalasban_jok_vagyunk.html $(TMPDIR)/posts/Haptic_feedback_hatodik_érzék.html $(TMPDIR)/posts/wshare_-_sharing_the_internet_over_wifi.html $(TMPDIR)/posts/oblig_First_POST!_.html
