#jQuery.noConflict()
jQuery(document).ready ($) ->

  #"use strict"

  # trips data
  qm_data = [
    {
      name: 'Rajoy'
      label: 'pp'
      year: '(2011-)' 
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/31/icon_225px-Mariano_Rajoy__diciembre_de_2011_.jpg'
      description: 'Ha confiado en más de 170 personas para representar a España ante organismos internacionales o países extranjeros. Dos de sus exministros y uno de Aznar fueron premiados con embajadas en Washington, Londres y París.'
      items: [
        {
          name: "Pedro Morenés",
          short_name: 'Morenés',
          position: "Ministro de Defensa entre 2011 y 2016",
          year: '2017',
          countries: "Estados Unidos"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/125/icon_ministro-Morenes.jpg'
          link: 'pedro-morenes'
        },
        {
          name: "José Ignacio Wert",
          short_name: 'Wert',
          position: "Ministro de Educación entre 2011 y 2015",
          year: '2015',
          countries: "OCDE (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/128/icon_origin_9087107686.jpg'
          link: 'jose-ignacio-wert'
        },
        {
          name: "Federico Trillo",
          short_name: 'Trillo',
          position: "Fue ministro de Defensa de Aznar",
          year: '2012-2017',
          countries: "Reino Unido"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14072/icon_Captura_de_pantalla_2015-09-30_a_las_10.00.28.png'
          link: 'federico-trillo'
        }
      ]
    },
    {
      name: 'Zapatero'
      label: 'psoe'
      year: '(2004-2011)' 
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/30/icon_Zapatero_ceja_4.jpg'
      description: 'Es el presidente que más embajadores "políticos" ha nombrado. De los 248 embajadores con los que contó, 11 no pertenecían al servicio diplomático.'
      items: [
        {
          name: "Silvia Iranzo",
          short_name: 'Iranzo',
          position: "Secretaria de Estado de Comercio entre 2008 y 2010",
          year: '2010-2012',
          countries: "Bélgica"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14409/icon_Captura_de_pantalla_2017-04-04_a_las_16.37.52.png'
          link: 'silvia-iranzo-gutierrez'
        },
        {
          name: "Cristina Narbona",
          short_name: 'Narbona',
          position: "Ministra de Medio Ambiente entre 2004 y 2008",
          year: '2008-2011',
          countries: "OCDE (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/166/icon_Cristina_Narbona_300912.jpg_1232443110.jpg'
          link: 'cristina-narbona'
        },
        {
          name: "Javier Sancho",
          short_name: "Sancho",
          position: "Director del gabinete de M.Á. Moratinos hasta 2008",
          year: '2008-2012',
          countries: "Organización de Estados Americanos"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14411/icon_Captura_de_pantalla_2017-04-04_a_las_19.03.43.png'
          link: 'javier-sancho-velazquez'
        },
        {
          name: "Joan Clos",
          short_name: "Clos",
          position: "Exministro de Industria y exalcalde de Barcelona",
          year: '2008-2010',
          countries: "Turquía y Azarbaiyán"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/10424/icon_perfil.JPG'
          link: 'joan-clos'
        },
        {
          name: "Miguel Ángel Cortizo",
          short_name: "Cortizo",
          position: "Diputado en el parlamento de Galicia entre 1990 y 2004",
          year: '2007-2011',
          countries: "Paraguay"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14413/icon_Captura_de_pantalla_2017-04-04_a_las_19.25.15.png'
          link: 'miguel-angel-cortizo-nieto'
        },
        {
          name: "María Jesús San Segundo",
          short_name: "San Segundo",
          position: "Ministra de Educación y Ciencia entre 2004 y 2006",
          year: '2006-2010',
          countries: "UNESCO (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14417/icon_Captura_de_pantalla_2017-04-06_a_las_11.18.15.png'
          link: 'maria-jesus-san-segundo-gomez-de-cadinanos'
        },
        {
          name: "Rafael Estrella",
          short_name: "Estrella",
          position: "Diputado y senador del PSOE",
          year: '2006-2012',
          countries: "Argentina"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/11897/icon_images.jpg'
          link: 'rafael-estrella'
        },
        {
          name: "Francisco José Vázquez",
          short_name: "Vázquez",
          position: "Alcalde de A Coruña entre 1983 y 2006",
          year: '2006-2011',
          countries: "Santa Sede y en la Soberana y Militar Orden de Malta"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14418/icon_Captura_de_pantalla_2017-04-06_a_las_11.54.11.png'
          link: 'francisco-jose-vazquez-vazquez'
        },
        {
          name: "Luis Planas",
          short_name: "Planas",
          position: "Diputado del PSOE",
          year: '2004-2011',
          countries: "la Unión Europea y Marruecos"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14419/icon_Captura_de_pantalla_2017-04-06_a_las_11.57.25.png'
          link: 'luis-planas-puchades'
        },
        {
          name: "Fernando Ballestero",
          short_name: "Ballestero",
          position: "Fue asesor económico de J.L. Zapatero",
          year: '2004-2008',
          countries: "OCDE (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14420/icon_6544392a568a5035b1adf291fe609614b0da3d08.jpg'
          link: 'fernando-ballestero-diaz'
        },
        {
          name: "Raúl Morodo",
          short_name: "Morodo",
          position: "Confundador del Partido Socialista Popular con Enrique Tierno Galván",
          year: '2004-2007',
          countries: "Venezuela, Trinidad y Tobago, Guyana y Surinam"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'raul-morodo-leoncio'
        },
        {
          name: "Germán Bejarano",
          short_name: "Bejarano",
          position: "Técnico Comercial y Economista del Estado",
          year: '2004-2007',
          countries: "Malasia y Brunei"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'german-bejarano-garcia'
        }
      ]
      },
    {
      name: 'Aznar'
      label: 'pp'
      year: '(1996-204)' 
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/4/icon_aznar.jpg'
      description: 'En sus dos legislaturas nombró a 182 embajadores, que se alternaron entre varias embajadas. Solo dos personas de las designadas no eran miembros del cuerpo diplomático.'
      items: [
        {
          name: "María Elena Pisonero",
          short_name: "Pisonero",
          position: "Secretaria de Estado de Comercio con el PP",
          year: '2000-2004',
          countries: "OCDE (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/9749/icon_Captura_de_pantalla_2017-04-06_a_las_12.14.23.png'
          link: 'elena-pisonero-ruiz'
        },
        {
          name: "José Luis Feito",
          short_name: "Feito",
          position: "Técnico Comercial y Economista del Estado",
          year: '1996-2000',
          countries: "OCDE (París)"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'jose-luis-feito-higueruela'
        }
      ]
    },
    {
      name: 'González'
      label: 'psoe'
      year: '(1982-1996)' 
      description: 'A lo largo de sus 14 años en el cargo nombró a 223 embajadores. De todos ellos, 10 no pertenecían a la carrera diplomática.'
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/3/icon_origin_2259454273.jpg'
      items: [
        {
          name: "Claudio Aranzadi",
          short_name: "Aranzadi",
          position: "Ministro de Industria entre 1988 y 1993",
          year: '1993-1996',
          countries: "OCDE (París)"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/12975/icon_CE2.JPG'
          link: 'claudio-aranzadi'
        },
        {
          name: "Alberto de Armas",
          short_name: "de Armas",
          position: "Exsenador del PSOE",
          year: '1990-1993',
          countries: "Venezuela, Guyana, Trinidad y Tobago y Surinam"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14422/icon_S4138.gif'
          link: 'alberto-de-armas-garcia'
        },
        {
          name: "Julián Santamaría",
          short_name: "Santamaría",
          position: "Exdirector del CIS",
          year: '1987-1990',
          countries: "Estados Unidos"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'julian-santamaria-ossorio'
        },
        {
          name: "Fernando Álvarez de Miranda",
          short_name: "Á. de Miranda",
          position: "Presidente del Congreso (UCD)",
          year: '1986-1989',
          countries: "El Salvador"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14424/icon_Captura_de_pantalla_2017-04-06_a_las_12.28.00.png'
          link: 'fernando-alvarez-de-miranda-torres'
        },
        {
          name: "Raúl Morodo",
          short_name: "Morodo",
          position: "Confundador del Partido Socialista Popular con Enrique Tierno Galván",
          year: '1983-1985 y 1995-1999',
          countries: "UNESCO (París) y Portugal"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'raul-morodo-leoncio'
        },
        {
          name: "Emilio Menéndez",
          short_name: "Menéndez",
          position: "Tras ser embajador fue eurodiputado del PSOE",
          year: '1983-1994',
          countries: "Jordania, Italia, San Marino y Albania"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14426/icon_4348.jpg'
          link: 'emilio-menendez-del-valle'
        },
        {
          name: "Eduardo Foncillas",
          short_name: "Foncillas",
          position: "Militante del PSP de Tierno Galván",
          year: '1983-1991',
          countries: "República Federal de Alemania"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'eduardo-foncillas-casaus'
        },
        {
          name: "Jorge de Esteban",
          short_name: "de Esteban",
          position: "Catedrático de derecho constitucional",
          year: '1983-1987',
          countries: "Italia"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14428/icon_Captura_de_pantalla_2017-04-06_a_las_12.34.46.png'
          link: 'jorge-de-esteban-alonso'
        },
        {
          name: "Fernando Baeza",
          short_name: "Baeza",
          position: "Exsenador del PSOE",
          year: '1983-1987',
          countries: "el Consejo de Europa"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14429/icon_S1013.gif'
          link: 'fernando-baeza-martos'
        },
        {
          name: "Joan Reventós",
          short_name: "Reventós",
          position: "Fundador del PSC",
          year: '1983-1986',
          countries: "Francia"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'joan-raventos-carner'
        }
      ]
    }
  ]

  default_img = 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'

  setupVisualization = ->
    console.log 'setupVisualization', qm_data
    $el = $('#qm-ambassadors')
    # loop throught each trip
    for term in qm_data
      #console.log year, items
      $term = $('<div class="qm-ambassador-term"></div>')
      $term.append '<div class="qm-ambassador-picture qm-ambassador-picture-term '+term.label+'" style="background-image: url('+term.img+'")"></div><h3>'+term.name+'<small>'+term.year+'</small></h3><p>'+term.description+'</p>'
      $items = $('<div class="qm-ambassadors-container"></div>')
      $items.append '<span class="qm-ambassadors-container-title">'+term.items.length+' embajadores sin carrera diplomática</span>'
      for item in term.items
        popoverContent = item.position+'.<br/>Embajador/a en '+item.countries+' ('+item.year+')'
        $item = $('<div class="qm-ambassador"></div>')
        $item.append '<a href="http://quienmanda.es/people/'+item.link+'" title="'+item.name+'" role="button" data-toggle="popover" data-placement="top" data-content="'+popoverContent+'"><div class="qm-ambassador-picture '+term.label+'" style="background-image: url('+item.img+'")"></div><h4>'+item.short_name+'</h4></a>'
        $items.append $item
      $term.append $items
      $el.append $term
    $('.qm-ambassador a').popover {trigger: 'hover', html: true}

  setupVisualization()
