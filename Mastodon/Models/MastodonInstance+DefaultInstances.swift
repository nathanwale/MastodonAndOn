//
//  MastodonInstance+DefaultInstances.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/12/2023.
//

import Foundation

///
/// Default instance and list of instances
///
extension MastodonInstance
{
    /// Default Mastodon instance host
    static let defaultHost = "mastodon.social"
    
    /// Default Mastodon instance hosts, for selection at login
    static var defaultHosts: [String] {
        [
          "mastodon.social",
          "mstdn.jp",
          "mstdn.social",
          "mastodon.online",
          "mastodon.world",
          "mas.to",
          "infosec.exchange",
          "hachyderm.io",
          "troet.cafe",
          "m.cmx.im",
          "mastodon.uno",
          "techhub.social",
          "universeodon.com",
          "piaille.fr",
          "mastodonapp.uk",
          "mastodon.gamedev.place",
          "mastodon.nl",
          "social.vivaldi.net",
          "mastodon-japan.net",
          "mastodon.sdf.org",
          "c.im",
          "mstdn.ca",
          "det.social",
          "kolektiva.social",
          "masto.ai",
          "norden.social",
          "social.tchncs.de",
          "sfba.social",
          "nrw.social",
          "mstdn.party",
          "tech.lgbt",
          "mastodon.scot",
          "aus.social",
          "mathstodon.xyz",
          "toot.community",
          "ohai.social",
          "sueden.social",
          "mastodon.ie",
          "occm.cc",
          "mastodon.top",
          "mastodontech.de",
          "mastodon.nu",
          "mindly.social",
          "masto.es",
          "ioc.exchange",
          "hessen.social",
          "ruhr.social",
          "mastodon.au",
          "social.cologne",
          "nerdculture.de",
          "muenchen.social",
          "mastodon.green",
          "mastouille.fr",
          "defcon.social",
          "mastodon.nz",
          "social.linux.pizza",
          "livellosegreto.it",
          "ieji.de",
          "indieweb.social",
          "tkz.one",
          "ruby.social",
          "mastodon.com.tr",
          "mastodont.cat",
          "ravenation.club",
          "noc.social",
          "toot.io",
          "sciences.social",
          "mastodontti.fi",
          "toot.wales",
          "masto.nu",
          "freemasonry.social",
          "social.dev-wiki.de",
          "persiansmastodon.com",
          "climatejustice.social",
          "urbanists.social",
          "mstdn.plus",
          "phpc.social",
          "cyberplace.social",
          "metalhead.club",
          "mastodon.iriseden.eu",
          "pol.social",
          "mastodon.ml",
          "dresden.network",
          "rollenspiel.social",
          "wien.rocks",
          "feuerwehr.social",
          "socel.net",
          "bark.lgbt",
          "mastodon.eus",
          "glasgow.social",
          "stranger.social",
          "mstdn.games",
          "mast.lat",
          "mastodon.me.uk",
          "snabelen.no",
          "hostux.social",
          "theblower.au",
          "h4.io",
          "uri.life",
          "freiburg.social",
          "mastodon-belgium.be",
          "masto.pt",
          "rheinneckar.social",
          "awscommunity.social",
          "geekdom.social",
          "tooot.im",
          "hcommons.social",
          "toad.social",
          "graphics.social",
          "tooting.ch",
          "fairy.id",
          "mastodon.berlin",
          "toot.aquilenet.fr",
          "furry.engineer",
          "mapstodon.space",
          "discuss.systems",
          "lor.sh",
          "peoplemaking.games",
          "flipboard.social",
          "union.place",
          "sunny.garden",
          "qdon.space",
          "bonn.social",
          "vmst.io",
          "opalstack.social",
          "tilde.zone",
          "famichiki.jp",
          "cupoftea.social",
          "blorbo.social",
          "rivals.space",
          "emacs.ch",
          "pawb.fun",
          "mast.dragon-fly.club",
          "historians.social",
          "ludosphere.fr",
          "expressional.social",
          "vkl.world",
          "fandom.ink",
          "retro.pizza",
          "convo.casa",
          "4bear.com",
          "disabled.social",
          "mastodon.gal",
          "oslo.town",
          "shelter.moe",
          "mastorol.es",
          "mastodonbooks.net",
          "veganism.social",
          "eupolicy.social",
          "lgbtqia.space",
          "witter.cz",
          "masto.nobigtech.es",
          "fulda.social",
          "toot.funami.tech",
          "dizl.de",
          "darmstadt.social",
          "sakurajima.moe",
          "furries.club",
          "pnw.zone",
          "mastodon.arch-linux.cz",
          "mastodon.energy",
          "mastodon.uy",
          "libretooth.gr",
          "mustard.blog",
          "xarxa.cloud",
          "mstdn.business",
          "urusai.social",
          "mastodon-uk.net",
          "cr8r.gg",
          "gaygeek.social",
          "federated.press",
          "archaeo.social",
          "thecanadian.social",
          "machteburch.social",
          "corteximplant.com",
          "mastodon.london",
          "muri.network",
          "babka.social",
          "mastodon.cat",
          "toot.site",
          "donphan.social",
          "mograph.social",
          "tyrol.social",
          "social.bau-ha.us",
          "kanoa.de",
          "masto.nyc",
          "toot.kif.rocks",
          "is.nota.live",
          "burma.social",
          "ani.work",
          "mast.hpc.social",
          "social.politicaconciencia.org",
          "mstdn.dk",
          "mastodon.com.pl",
          "mastoot.fr",
          "drupal.community",
          "est.social",
          "wargamers.social",
          "social.seattle.wa.us",
          "genealysis.social",
          "qaf.men",
          "musicians.today",
          "norcal.social",
          "dmv.community",
          "hometech.social",
          "wehavecookies.social",
          "seocommunity.social",
          "cyberfurz.social",
          "epicure.social",
          "guitar.rodeo",
          "irsoluciones.social",
          "kurry.social",
          "mastodon.pnpde.social",
          "h-net.social",
          "beekeeping.ninja",
          "occitania.social",
          "nederland.online",
          "bookstodon.com",
          "bahn.social",
          "fedi.at",
          "arsenalfc.social",
          "cloud-native.social",
          "mastodon-swiss.org",
          "mountains.social",
          "augsburg.social",
          "mastodon.education",
          "apobangpo.space",
          "opencoaster.net",
          "mastodon.vlaanderen",
          "hispagatos.space",
          "esq.social",
          "gametoots.de",
          "kfem.cat",
          "mastodon.com.py",
          "friendsofdesoto.social",
          "linux.social",
          "mastodon.wien",
          "birdon.social",
          "aut.social",
          "datasci.social",
          "colorid.es",
          "gamepad.club",
          "musician.social",
          "lgbt.io",
          "arvr.social",
          "hear-me.social",
          "mastodon.free-solutions.org",
          "social.silicon.moe",
          "lewacki.space",
          "cosocial.ca",
          "ciberlandia.pt",
          "tooter.social",
          "puntarella.party",
          "lounge.town",
          "allthingstech.social",
          "squawk.mytransponder.com",
          "neovibe.app",
          "furry.energy",
          "gardenstate.social",
          "earthstream.social",
          "frikiverse.zone",
          "musicworld.social",
          "theatl.social",
          "maly.io",
          "metalverse.social",
          "poweredbygay.social",
          "toot.garden",
          "airwaves.social",
          "tuiter.rocks",
          "masto.yttrx.com",
          "ruhrpott.social",
          "library.love",
          "clj.social",
          "drumstodon.net",
          "mastodon.pirateparty.be",
          "indieauthors.social",
          "lou.lt",
          "jvm.social",
          "mastodon.cr",
          "anime.kona.moe",
          "seo.chat",
          "mastodon.cipherbliss.com",
          "fikaverse.club",
          "synapse.cafe",
          "cultur.social",
          "raphus.social",
          "mastodon.bachgau.social",
          "planetearth.social",
          "elizur.me",
          "khiar.net",
          "mastodon.hosnet.fr",
          "bzh.social",
          "mastodon.africa",
          "toot.pizza",
          "fribygda.no",
          "toots.nu",
          "lsbt.me",
          "social.sndevs.com",
          "vermont.masto.host",
          "rail.chat",
          "t.chadole.com",
          "techtoots.com",
          "mastodon.holeyfox.co",
          "stereodon.social",
          "burningboard.net",
          "bologna.one",
          "rheinhessen.social",
          "tchafia.be",
          "hoosier.social",
          "toot.re",
          "x0r.be",
          "mastodon.sg",
          "leipzig.town",
          "k8s.social",
          "mastodon.escepticos.es",
          "cville.online",
          "skastodon.com",
          "episcodon.net",
          "travelpandas.fr",
          "camp.smolnet.org",
          "mcr.wtf",
          "balkan.fedive.rs",
          "frontrange.co",
          "fairmove.net",
          "okla.social",
          "mastodon.bot",
          "devianze.city",
          "growers.social",
          "nomanssky.social",
          "cwb.social",
          "mastodon.ee",
          "tu.social",
          "mastodon.iow.social",
          "epsilon.social",
          "mikumikudance.cloud",
          "mastodon.conquestuniverse.com",
          "silversword.online",
          "mastodon.frl",
          "kcmo.social",
          "nwb.social",
          "social.diva.exchange",
          "pdx.sh",
          "paktodon.asia",
          "openedtech.social",
          "ailbhean.co-shaoghal.net",
          "nutmeg.social",
          "voi.social",
          "mastodon.ph",
          "zenzone.social",
          "nfld.me",
          "toot.works",
          "fpl.social",
          "neurodiversity-in.au",
          "kzoo.to",
          "mastodon.babb.no",
          "apotheke.social",
          "xreality.social",
          "mastodon.mg",
          "enshittification.social",
          "dariox.club",
          "rap.social",
          "mastodon.vanlife.is",
          "23.illuminati.org",
          "social.ferrocarril.net",
          "biplus.social",
          "sanjuans.life",
          "spojnik.works",
          "jaxbeach.social",
          "netsphere.one",
          "ms.maritime.social",
          "ceilidh.online",
          "polsci.social",
          "technews.social",
          "troet.fediverse.at",
          "darticulate.com",
          "publishing.social",
          "cartersville.social",
          "vidasana.social",
          "streamerchat.social",
          "bvb.social",
          "pool.social",
          "finsup.social",
          "persia.social",
          "hobbymetzgerei.de",
          "kjas.no",
          "wxw.moe",
          "tea.codes",
          "mastodon.bida.im",
          "computerfairi.es",
          "social.veraciousnetwork.com",
          "learningdisability.social",
          "social.porto.digital"
        ].sorted()
    }
}
