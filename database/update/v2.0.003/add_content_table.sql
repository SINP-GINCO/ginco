CREATE TABLE website.content (
  name VARCHAR(50) NOT NULL,
  value TEXT DEFAULT NULL,
  description VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY(name)
);
CREATE UNIQUE INDEX UNIQ_3211DD035E237E06 ON website.content (name);

ALTER TABLE website.content
  OWNER TO admin;
GRANT ALL ON TABLE website.content TO admin;
GRANT ALL ON TABLE website.content TO ogam;

INSERT INTO website.content ("name",value,description) VALUES
  ('homepage.title','@site.name@','Titre page d''accueil'),
  ('homepage.intro','<div>
<div>Bienvenue sur @site.name@, la plateforme r&eacute,gionale du Syst&egrave,me d&rsquo,Information Nature et Paysage (SINP).&nbsp, La plateforme est un outil de <strong>versement, traitement, et diffusion de donn&eacute,es naturalistes</strong>.</div>

<div>Les producteurs de donn&eacute,es de la r&eacute,gion peuvent transmettre leurs donn&eacute,es afin qu&#39,elles soient int&eacute,gr&eacute,es dans la plateforme et transmises &agrave, la plateforme nationale (INPN).</div>

<div>Les visiteurs non loggu&eacute,s ont acc&egrave,s &agrave, l&#39,ensemble des donn&eacute,es de la plateforme, avec une restitution g&eacute,ographique &agrave, la commune. Les utilisateurs authentifi&eacute,s ont acc&egrave,s aux donn&eacute,es pr&eacute,cises.</div>

<div>Les donn&eacute,es actuellement pr&eacute,sentes dans la plateforme sont des observations de faune, flore et fonge. &nbsp,</div>
</div>','Texte d''introduction sur la page d''accueil'),
  ('homepage.image','marais.jpg','Image d''illustration sur la page d''accueil'),
  ('homepage.links.title','Plus d''informations','Titre du bloc de liens publics sur la page d''accueil'),
  ('homepage.link.1','{"anchor":"Pr\u00e9sentation du SINP","href":"http:\/\/www.naturefrance.fr","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.2','{"anchor":"INPN - Inventaire National du Patrimoine Naturel","href":"https:\/\/inpn.mnhn.fr","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.3','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page accueil'),
  ('homepage.link.4','{"anchor":"Projet Ginco","href":"https:\/\/ginco.naturefrance.fr","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.5','{"anchor":"Aide en ligne de la plateforme","href":"@documentation.url@","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.doc.1','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.2','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.3','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.4','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.5','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.private.links.title','Informations Producteurs','Titre du bloc de liens privés sur la page d''accueil'),
  ('homepage.private.link.1','{"anchor":"Plateforme de m\u00e9tadonn\u00e9es","href":"https:\/\/inpn.mnhn.fr\/mtd","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.2','{"anchor":"Standards du SINP","href":"http:\/\/standards-sinp.mnhn.fr\/","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.3','{"anchor":null,"href":null,"target":"_self"}','Lien privé sur page accueil'),
  ('homepage.private.link.4','{"anchor":null,"href":null,"target":"_self"}','Lien privé sur page accueil'),
  ('homepage.private.link.5','{"anchor":null,"href":null,"target":"_self"}','Lien privé sur page accueil'),
  ('homepage.private.doc.1','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.2','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.3','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.4','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.5','{"anchor":null,"file":""}','document privé sur page accueil'),

  ('presentation.title','Présentation du SINP régional','Titre de la page de presentation'),
  ('presentation.intro','<div>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce malesuada tincidunt nisi. Fusce orci mauris, pharetra ac ipsum ornare, interdum pretium velit. Ut sed diam ut felis bibendum lacinia. Donec id pulvinar massa. Integer malesuada, lorem vel sodales tincidunt, felis nunc accumsan magna, nec commodo justo purus sit amet tellus. Vivamus hendrerit varius massa eu varius. Duis sit amet quam et tellus maximus lacinia. Nulla turpis velit, dapibus nec sagittis sit amet, luctus vulputate augue. Etiam a tortor accumsan quam placerat facilisis nec in tellus. Ut id quam mi. Nunc dignissim nulla vel ultrices sollicitudin. Vestibulum molestie ac diam vitae vulputate. Sed pretium erat id tortor iaculis, ac rutrum dui facilisis. Quisque mauris mi, ultrices in aliquet at, tristique non risus.</p>

<p>Aenean id magna ut sem feugiat convallis. Fusce rutrum dui justo, sit amet sollicitudin orci tristique et. Duis nec malesuada mauris. Vestibulum arcu ex, tempus nec justo non, pellentesque dictum tellus. Suspendisse at vulputate urna. Morbi congue nisi dignissim, dictum ipsum vel, rutrum lectus. Nam tincidunt eleifend nulla, a porta lectus consequat id. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla maximus odio commodo tempus elementum. Ut ut dui ullamcorper, placerat odio non, imperdiet ante. Integer pulvinar molestie magna, consequat dignissim tellus dapibus ut. Sed placerat bibendum eleifend. Praesent sed est erat. In posuere ante eget dolor elementum sollicitudin.</p>

<p>Aenean vehicula sem diam, non efficitur mauris feugiat non. Phasellus rutrum nisl vel dolor cursus hendrerit. Nam nec lorem tincidunt, tempor dolor faucibus, facilisis massa. Etiam non rutrum tortor, nec aliquet elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi euismod in diam at cursus. Integer sed augue nisl.</p>

<p>Duis suscipit, nibh ac faucibus ultricies, eros eros gravida ex, vel gravida nisl lacus quis purus. Aliquam fringilla tincidunt commodo. Maecenas viverra mauris at lacus pulvinar, tincidunt lobortis arcu elementum. Proin eu metus scelerisque, iaculis sapien nec, varius sapien. Phasellus tristique vel neque ullamcorper maximus. Mauris ornare mauris at ipsum euismod volutpat. Etiam aliquet metus quis viverra sodales. Etiam ut risus eu eros mollis consectetur. Curabitur ligula enim, malesuada nec eros at, finibus lacinia tortor. Fusce vehicula, lectus eget accumsan ultrices, erat mauris ultrices massa, vel mollis mauris dolor fermentum turpis. Duis fringilla libero sit amet nulla semper, sed tincidunt nisi blandit. Duis tincidunt, eros eget lobortis finibus, eros sem tincidunt odio, in efficitur libero nulla ut mi. Proin ultricies ultricies tortor vitae ultrices. Etiam semper tincidunt lacus, ac imperdiet lectus commodo eu.</p>

<p>In condimentum eu erat in gravida. Vestibulum efficitur vehicula lorem. Quisque quis tincidunt justo. Ut sit amet nibh fringilla, venenatis leo nec, elementum lorem. Donec nisi dolor, egestas a augue non, porta sagittis lorem. Vestibulum vel pretium nisl. Nulla ut efficitur magna, in ultrices quam. Nullam mollis tellus in ante fermentum pellentesque. Nulla at aliquam dui. Nam ac nunc tempus, condimentum mi sit amet, gravida odio. Quisque a dignissim enim. Suspendisse consequat gravida neque, in venenatis nibh hendrerit dictum. Sed sagittis facilisis ipsum vitae tincidunt. Nulla et dolor vitae eros aliquet cursus a ut lorem. Sed vitae ante tempus, efficitur nisl quis, blandit lacus. Pellentesque iaculis lorem lorem.</p>
</div>','Texte d''introduction sur la page de presentation'),
  ('presentation.image','montagne.jpg','Image d''illustration sur la page de presentation'),
  ('presentation.links.title','Sites et documents de référence','Titre du bloc de liens publics sur la page de presentation'),
  ('presentation.link.1','{"anchor":null,"href":null,"target":"_blank"}','Lien public sur page de presentation'),
  ('presentation.link.2','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.link.3','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.link.4','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.link.5','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.doc.1','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.2','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.3','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.4','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.5','{"anchor":null,"file":""}','Document public sur page de presentation');


