package fr.ifn.ogam.integration.business;

/**
 * Values for testing ComputeGeoAssocationService methods.
 * 
 * @author gpastakia
 *
 */
public class DataValues {

	public static final String[] OGAM_IDS = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
			"21", "22" };

	public static final String[] PROVIDER_IDS = { "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1",
			"1" };

	public static final String[] GEOMETRIES = { "POINT(5.75035744012219 48.311889363399679)", "POINT(-52.593480 4.854747)",
			"MULTIPOINT((-52.593480 4.854747), (-52.623911 4.900012), (-52.573786 4.938152))", "LINESTRING (-52.593480 4.854747, -52.489500 4.871449)", null,
			"MULTILINESTRING((-52.593480 4.854747, -52.489500 4.871449),(-52.623911 4.900012, -52.573786 4.938152))",
			"POLYGON((7.8493 48.9390, 7.9442 48.9353, 7.9681 48.8574, 7.8353 48.8748, 7.8493 48.9390))", "POINT(2.15035744016219 48.711889363399679)",
			"LINESTRING(2.423033 48.846034, 2.426026 48.859478)", null,
			"POLYGON((2.472870 48.844937, 2.471352 48.840363, 2.476845 48.840363, 2.476269 48.847313, 2.466801 48.847752, 2.472870 48.844937))",
			"MULTIPOLYGON (((7.8697 48.8768, 7.8486 48.8736, 7.8678 48.8475,7.8697 48.8768)), ((7.7881 48.8264, 7.7785 48.8045, 7.8058 48.7937,7.7881 48.8264 )))",
			"MULTIPOLYGON (((7.8697 48.8768, 7.8486 48.8736, 7.8678 48.8475,7.8697 48.8768)), ((7.7881 48.8264, 7.7785 48.8045, 7.8058 48.7937,7.7881 48.8264 )), "
					+ "((7.9042 48.7494, 7.9206 48.7430, 7.9528 48.7595, 7.9099 48.7745,7.9042 48.7494)))",
			null, null, null, null, null, "POINT(8.23016 48.9661)", null, "LINESTRING(4.6210639 43.606664, 4.6210639 43.606664)",
			"POLYGON((4.6210639 43.906664, 4.6210639 43.906664, 4.6210639 43.906664, 4.6210639 43.906664, 4.6210639 43.906664, 4.6210639 43.906664))" };

	public static final String[][] CODE_COMMUNES = { { "97313" }, { "" }, { "" }, { "97313" }, { "97129", "97111", "97121", "97106" }, { "" }, { "94080" },
			{ "" }, { "" }, { "" }, { "94080" }, { "" }, { "94080" }, { "67444" }, { "67444" }, { "" }, { "" }, { "" }, { "" }, { "94080", "94067" }, { "" },
			{ "" } };

	public static final String[][] NOM_COMMUNES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "Vincennes", "Saint-Mandée" }, { "" }, { "" } };

	public static final String[][] CODE_MAILLES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "E041N653", "E041N652", "E042N652" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "E041N653", "E041N652", "E042N652" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" } };

	public static final String[][] CODE_DEPARTEMENTS = { { "" }, { "" }, { "" }, { "" }, { "971" }, { "" }, { "" }, { "17" }, { "94" }, { "17" }, { "" },
			{ "" }, { "94" }, { "17" }, { "" }, { "" }, { "78" }, { "95" }, { "77" }, { "94" }, { "" }, { "" } };

	public static final String[] TYPE_INFO_GEO_COMMUNES = { null, null, null, null, null, null, null, null, null, null, null, null, null, null, "1", null, null,
			null, null, null, null, null };

	public static final String[] TYPE_INFO_GEO_MAILLES = { null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, "1", null,
			null, null, null, null, null };

	public static final String[] TYPE_INFO_GEO_DEPARTEMENTS = { null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
			null, "1", null, null, null, null };

	public static final String[] SENSI_NIVEAUX = { null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
			null, null, null, null };

	public static final String[][] CODE_COMMUNE_CALCULES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" } };

	public static final String[][] NOM_COMMUNE_CALCULES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" } };

	public static final String[][] CODE_MAILLE_CALCULES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" } };

	public static final String[][] CODE_DEPARTEMENT_CALCULES = { { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" },
			{ "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" }, { "" } };

	public static final String[][] NOM_COMMUNE_CALCULES_EXPECTED = { { "CERTILLEUX" }, { "MONTSINERY-TONNEGRANDE" },
			{ "MONTSINERY-TONNEGRANDE", "KOUROU", "MACOURIA" }, { "MONTSINERY-TONNEGRANDE" }, { "SAINTE-ROSE", "DESHAIES", "POINTE-NOIRE", "BOUILLANTE" },
			{ "KOUROU", "MACOURIA", "MONTSINERY-TONNEGRANDE" },
			{ "KUTZENHAUSEN", "RITTERSHOFFEN", "HAGUENAU", "SURBOURG", "LEUTENHEIM", "HOFFEN", "BETSCHDORF", "SOULTZ-SOUS-FORETS" }, { "SAINT-AUBIN" },
			{ "VINCENNES", "MONTREUIL" }, { "" }, { "FONTENAY-SOUS-BOIS", "NOGENT-SUR-MARNE" }, { "HAGUENAU" },
			{ "ROHRWILLER", "OBERHOFFEN-SUR-MODER", "HAGUENAU", "DRUSENHEIM", "HERRLISHEIM" }, { "SCHERLENHEIM" }, { "SCHERLENHEIM" },
			{ "ECURAT", "LA CHAPELLE-DES-POTS", "TAILLANT", "VARZAY", "CHERAC", "SAINT-BRIS-DES-BOIS", "LE DOUHET", "SAINT-CESAIRE", "ECOYEUX", "SAINT-SAUVANT",
					"LES GONDS", "FENIOUX", "CRAZANNES", "ANNEPONT", "SAINT-VAIZE", "BUSSAC-SUR-CHARENTE", "SAINT-GEORGES-DES-COTEAUX", "GEAY", "VENERAND",
					"NIEUL-LES-SAINTES", "BRIZAMBOURG", "PESSINES", "PLASSAY", "CHANIERS", "TAILLEBOURG", "BORDS", "LE MUNG", "COURCOURY", "FONTCOUVERTE",
					"SAINTES", "SAINT-SAVINIEN", "PORT-D'ENVAUX", "GRANDJEAN" },
			{ "" },
			{ "SEUGY", "VILLIERS-LE-SEC", "CLERY-EN-VEXIN", "FROUVILLE", "HEROUVILLE", "NESLES-LA-VALLEE", "SAINT-OUEN-L'AUMONE", "LABBEVILLE", "ARRONVILLE",
					"MERY-SUR-OISE", "HERBLAY", "PIERRELAYE", "AUVERS-SUR-OISE", "AMBLEVILLE", "BUHY", "CHAUSSY", "HAUTE-ISLE", "CHERENCE", "VETHEUIL",
					"MONTREUIL-SUR-EPTE", "SAINT-CLAIR-SUR-EPTE", "LE BELLAY-EN-VEXIN", "MAREIL-EN-FRANCE", "AMENUCOURT", "LA ROCHE-GUYON", "BRAY-ET-LU",
					"BOISEMONT", "CERGY", "SERAINCOURT", "ERAGNY", "NEUVILLE-SUR-OISE", "JOUY-LE-MOUTIER", "CONDECOURT", "OSNY", "SANTEUIL", "PUISEUX-PONTOISE",
					"EPIAIS-RHUS", "GENAINVILLE", "BERVILLE", "HARAVILLIERS", "GENICOURT", "MENUCOURT", "NEUILLY-EN-VEXIN", "VIGNY", "CHARS", "FREMECOURT",
					"OMERVILLE", "MAUDETOUR-EN-VEXIN", "PONTOISE", "GUIRY-EN-VEXIN", "HODENT", "ABLEIGES", "MENOUVILLE", "VAUREAL", "LIVILLIERS",
					"LA CHAPELLE-EN-VEXIN", "GRISY-LES-PLATRES", "BANTHELU", "MARINES", "SAGY", "LONGUESSE", "VILLERS-EN-ARTHIES", "CORMEILLES-EN-VEXIN",
					"SAINT-GERVAIS", "LE HEAULME", "ENNERY", "THEMERICOURT", "THEUVILLE", "BOISSY-L'AILLERIE", "COMMENY", "GOUZANGREZ", "LE PERCHAY",
					"COURDIMANCHE", "GADANCOURT", "AVERNES", "VIENNE-EN-ARTHIES", "NUCOURT", "WY-DIT-JOLI-VILLAGE", "MOUSSY", "VALLANGOUJARD", "MONTGEROULT",
					"FREMAINVILLE", "AINCOURT", "CHARMONT", "MAGNY-EN-VEXIN", "BRIGNANCOURT", "BREANCON", "COURCELLES-SUR-VIOSNE", "ARTHIES", "US",
					"SAINT-CYR-EN-ARTHIES", "MONTMAGNY", "ENGHIEN-LES-BAINS", "BONNEUIL-EN-FRANCE", "MONTLIGNON", "SAINT-PRIX", "BESSANCOURT", "BOUQUEVAL",
					"LE PLESSIS-GASSOT", "TAVERNY", "LOUVRES", "ECOUEN", "EPIAIS-LES-LOUVRES", "SAINT-LEU-LA-FORET", "FONTENAY-EN-PARISIS", "EZANVILLE",
					"CHENNEVIERES-LES-LOUVRES", "BOUFFEMONT", "GOUSSAINVILLE", "DOMONT", "SARCELLES", "LE PLESSIS-BOUCHARD", "ERMONT", "PISCOP", "BEZONS",
					"CORMEILLES-EN-PARISIS", "GROSLAY", "SANNOIS", "ANDILLY", "FRANCONVILLE", "MONTIGNY-LES-CORMEILLES", "LA FRETTE-SUR-SEINE",
					"DEUIL-LA-BARRE", "EAUBONNE", "MONTMORENCY", "SAINT-GRATIEN", "ARGENTEUIL", "SAINT-BRICE-SOUS-FORET", "MARGENCY", "BEAUCHAMP",
					"SOISY-SOUS-MONTMORENCY", "GONESSE", "ARNOUVILLE", "LE THILLAY", "LASSY", "ROISSY-EN-FRANCE", "VAUDHERLAND", "VILLIERS-LE-BEL",
					"GARGES-LES-GONESSE", "SAINT-WITZ", "BRUYERES-SUR-OISE", "BEAUMONT-SUR-OISE", "BELLEFONTAINE", "BETHEMONT-LA-FORET", "LE MESNIL-AUBRY",
					"JAGNY-SOUS-BOIS", "VEMARS", "FREPILLON", "LUZARCHES", "ASNIERES-SUR-OISE", "MONTSOULT", "BUTRY-SUR-OISE", "SURVILLIERS",
					"CHATENAY-EN-FRANCE", "EPINAY-CHAMPLATREUX", "CHAUVRY", "VILLERON", "PERSAN", "BAILLET-EN-FRANCE", "VIARMES", "L'ISLE-ADAM", "MOISSELLES",
					"BELLOY-EN-FRANCE", "CHAMPAGNE-SUR-OISE", "BERNES-SUR-OISE", "MOURS", "SAINT-MARTIN-DU-TERTRE", "MERIEL", "CHAUMONTEL", "FOSSES",
					"VALMONDOIS", "PARMAIN", "MAFFLIERS", "VILLIERS-ADAM", "ATTAINVILLE", "NOISY-SUR-OISE", "NOINTEL", "LE PLESSIS-LUZARCHES",
					"PUISEUX-EN-FRANCE", "RONQUEROLLES", "PRESLES", "HEDOUVILLE", "MARLY-LA-VILLE", "VILLAINES-SOUS-BOIS", "NERVILLE-LA-FORET" },
			{ "LAUTERBOURG" }, { "VINCENNES", "SAINT-MANDE" }, { "ARLES" }, { "THEZIERS" } };

	public static final String[][] CODE_COMMUNE_CALCULES_EXPECTED = { { "88083" }, { "97313" }, { "97313", "97304", "97305" }, { "97313" },
			{ "97129", "97111", "97121", "97106" }, { "97304", "97305", "97313" }, { "67254", "67404", "67180", "67487", "67264", "67206", "67339", "67474" },
			{ "91538" }, { "94080", "93048" }, { "" }, { "94033", "94052" }, { "67180" }, { "67407", "67345", "67180", "67106", "67194" }, { "67444" },
			{ "67444" },
			{ "17148", "17089", "17435", "17460", "17100", "17313", "17143", "17314", "17147", "17395", "17179", "17157", "17134", "17011", "17412", "17073",
					"17336", "17171", "17462", "17262", "17070", "17275", "17280", "17086", "17436", "17053", "17252", "17128", "17164", "17415", "17397",
					"17285", "17181" },
			{ "" },
			{ "95594", "95682", "95166", "95258", "95308", "95446", "95572", "95328", "95023", "95394", "95306", "95488", "95039", "95011", "95119", "95150",
					"95301", "95157", "95651", "95429", "95541", "95054", "95365", "95012", "95523", "95101", "95074", "95127", "95592", "95218", "95450",
					"95323", "95170", "95476", "95584", "95510", "95213", "95270", "95059", "95298", "95271", "95388", "95447", "95658", "95142", "95254",
					"95462", "95379", "95500", "95295", "95309", "95002", "95387", "95637", "95341", "95139", "95287", "95046", "95370", "95535", "95348",
					"95676", "95177", "95554", "95303", "95211", "95610", "95611", "95078", "95169", "95282", "95483", "95183", "95259", "95040", "95656",
					"95459", "95690", "95438", "95627", "95422", "95253", "95008", "95141", "95355", "95110", "95102", "95181", "95024", "95625", "95543",
					"95427", "95210", "95088", "95426", "95574", "95060", "95094", "95492", "95607", "95351", "95205", "95212", "95563", "95241", "95229",
					"95154", "95091", "95280", "95199", "95585", "95491", "95219", "95489", "95063", "95176", "95288", "95582", "95014", "95252", "95424",
					"95257", "95197", "95203", "95428", "95555", "95018", "95539", "95369", "95051", "95598", "95277", "95019", "95612", "95331", "95527",
					"95633", "95680", "95268", "95580", "95116", "95052", "95055", "95061", "95395", "95316", "95641", "95256", "95352", "95026", "95430",
					"95120", "95604", "95144", "95214", "95151", "95675", "95487", "95042", "95652", "95313", "95409", "95056", "95134", "95058", "95436",
					"95566", "95392", "95149", "95250", "95628", "95480", "95353", "95678", "95028", "95456", "95452", "95493", "95509", "95529", "95504",
					"95304", "95371", "95660", "95445" },
			{ "67261" }, { "94080", "94067" }, { "13004" }, { "30328" } };

	public static final String[][] CODE_MAILLE_CALCULES_EXPECTED = { { "E090N680" }, { "W320N530" }, { "W320N530", "W310N540", "W320N540" },
			{ "W320N530", "W330N530" }, { "W630N1770", "W620N1780", "W630N1780", "W620N1790", "W630N1790", "W640N1790", "W620N1800", "W630N1800", "W640N1800" },
			{ "W320N530", "W330N530", "W310N540", "W320N540" }, { "E105N687", "E105N688", "E106N687", "E106N688" }, { "E063N684" }, { "E065N686" },
			{ "E041N653", "E041N652", "E042N652" }, { "E066N686" }, { "E105N686", "E105N687" }, { "E105N686", "E105N687", "E106N686" }, { "E103N686" },
			{ "E103N686" }, { "E041N653", "E041N652", "E042N652" },
			{ "E059N685", "E059N686", "E059N687", "E059N688", "E058N687", "E058N688", "E059N683", "E059N684", "E060N682", "E060N683", "E060N684", "E060N685",
					"E060N686", "E060N687", "E060N688", "E061N681", "E061N682", "E061N683", "E061N684", "E061N685", "E061N686", "E061N687", "E061N688",
					"E063N683", "E063N684", "E063N685", "E063N686", "E063N687", "E063N688", "E062N681", "E062N682", "E062N683", "E062N684", "E062N685",
					"E062N686", "E062N687", "E062N688", "E064N685", "E064N686", "E064N687" },
			{ "E059N688", "E059N689", "E060N688", "E060N689", "E060N690", "E061N687", "E061N688", "E061N689", "E063N687", "E063N688", "E063N689", "E063N690",
					"E062N687", "E062N688", "E062N689", "E064N686", "E064N687", "E064N688", "E064N689", "E065N687", "E065N688", "E065N689", "E067N688",
					"E066N687", "E066N688", "E066N689" },
			{ "E108N688" }, { "E065N685", "E065N686", "E066N686" }, { "E083N627" }, { "E083N631" } };

	public static final String[][] CODE_DEPARTEMENT_CALCULES_EXPECTED = { { "88" }, { "973" }, { "973" }, { "973" }, { "971" }, { "973" }, { "67" }, { "91" },
			{ "93", "94" }, { "17" }, { "94" }, { "67" }, { "67" }, { "67" }, { "67" }, { "17" }, { "78" }, { "95" }, { "67" }, { "94" }, { "13" }, { "30" } };
}
