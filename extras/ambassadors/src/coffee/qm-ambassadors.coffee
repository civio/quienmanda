#jQuery.noConflict()
jQuery(document).ready ($) ->

  #"use strict"

  # trips data
  qm_data = [
    {
      name: 'Rajoy'
      label: 'pp'
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/31/icon_225px-Mariano_Rajoy__diciembre_de_2011_.jpg'
      description: 'Lorem ipsum dolor sit amet'
      items: [
        {
          name: "Pedro Morenés",
          short_name: 'Morenés',
          position: "Exministro de Defensa",
          year: 2017,
          countries: "Estados Unidos"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/125/icon_ministro-Morenes.jpg'
          link: 'pedro-morenes'
        },
        {
          name: "José Ignacio Wert",
          short_name: 'Wert',
          position: "Exministro de Educación",
          year: 2015,
          countries: "la OCDE"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/128/icon_origin_9087107686.jpg'
          link: 'jose-ignacio-wert'
        },
        {
          name: "Federico Trillo",
          short_name: 'Trillo',
          position: "Exministro de Defensa",
          year: 2012,
          countries: "Reino Unido"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14072/icon_Captura_de_pantalla_2015-09-30_a_las_10.00.28.png'
          link: 'federico-trillo'
        }
      ]
    },
    {
      name: 'Zapatero'
      label: 'psoe'
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/30/icon_Zapatero_ceja_4.jpg'
      description: 'Lorem ipsum dolor sit amet'
      items: [
        {
          name: "Silvia Iranzo",
          short_name: 'Iranzo',
          position: "Fue Secretaria de Estado de Comercio entre 2008 y 2010",
          year: 2010,
          countries: "Bélgica"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14409/icon_Captura_de_pantalla_2017-04-04_a_las_16.37.52.png'
          link: 'silvia-iranzo-gutierrez'
        },
        {
          name: "Cristina Narbona",
          short_name: 'Narbona',
          position: "Fue ministra de Medio Ambiente entre 2004 y 2008",
          year: 2008,
          countries: "la OCDE"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/166/icon_Cristina_Narbona_300912.jpg_1232443110.jpg'
          link: 'cristina-narbona'
        },
        {
          name: "Javier Sancho",
          short_name: "Sancho",
          position: "Fue director del gabinete de Moratinos",
          year: 2008,
          countries: "la Organización de Estados Americanos"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14411/icon_Captura_de_pantalla_2017-04-04_a_las_19.03.43.png'
          link: 'javier-sancho-velazquez'
        },
        {
          name: "Joan Clos",
          short_name: "Clos",
          position: "Exministro de Industria y exalcalde de Barcelona",
          year: 2008,
          countries: "Turquía y Azarbaiyán"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/10424/icon_perfil.JPG'
          link: 'joan-clos'
        },
        {
          name: "Miguel Ángel Cortizo",
          short_name: "Cortizo",
          position: "Ex delegado del Gobierno y parlamentario gallego del PSOE",
          year: 2007,
          countries: "Paraguay"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/14413/icon_Captura_de_pantalla_2017-04-04_a_las_19.25.15.png'
          link: 'miguel-angel-cortizo-nieto'
        },
        {
          name: "María Jesús San Segundo",
          short_name: "San Segundo",
          position: "Fue ministra de Educación y Ciencia entre 2004 y 2006",
          year: 2006,
          countries: "la UNESCO"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'maria-jesus-san-segundo-gomez-de-cadinanos'
        },
        {
          name: "Rafael Estrella",
          short_name: "Estrella",
          position: "Diputado y senador del PSOE",
          year: 2006,
          countries: "Argentina"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/11897/icon_images.jpg'
          link: 'rafael-estrella'
        },
        {
          name: "Francisco José Vázquez",
          short_name: "Vázquez",
          position: "Exalcalde de A Coruña",
          year: 2006,
          countries: "la Santa Sede y en la Soberana y Militar Orden de Malta"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'francisco-jose-vazquez-vazquez'
        },
        {
          name: "Luis Planas",
          short_name: "Planas",
          position: "Diputado del PSOE",
          year: 2004,
          countries: "la Unión Europea y Marruecos"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'luis-planas-puchades'
        },
        {
          name: "Fernando Ballestero",
          short_name: "Ballestero",
          position: "Cuerpo de Técnicos Comerciales y Economistas del Estado. Fue asesor económico del presidente del Gobierno.",
          year: 2004,
          countries: "la OCDE"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'fernando-ballestero-diaz'
        },
        {
          name: "Germán Bejarano",
          short_name: "Bejarano",
          position: "Técnico Comercial y Economista del Estado. En 2008 fue nombrado director de RRII en Abengoa",
          year: 2004,
          countries: "Malasia y Brunei"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'german-bejarano-garcia'
        }
      ]
      },
    {
      name: 'Aznar'
      label: 'pp'
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/4/icon_aznar.jpg'
      description: 'Lorem ipsum dolor sit amet'
      items: [
        {
          name: "María Elena Pisonero",
          short_name: "Pisonero",
          position: "Secretria de Estado de Comercio con el PP",
          year: 2000,
          countries: "la OCDE"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'elena-pisonero-ruiz'
        },
        {
          name: "José Luis Feito",
          short_name: "Feito",
          position: "Técnico Comercial y Economista del Estado, con participación en empresas privadas",
          year: 1996,
          countries: "la OCDE"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'jose-luis-feito-higueruela'
        }
      ]
    },
    {
      name: 'González'
      label: 'psoe'
      description: 'Lorem ipsum dolor sit amet'
      img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/3/icon_origin_2259454273.jpg'
      items: [
        {
          name: "José Claudio Aranzadi",
          short_name: "Aranzadi",
          position: "Ministro entre 1988 y 1993",
          year: 1993,
          countries: "la OCDE"
          img: 'https://quienmanda.s3.amazonaws.com/uploads/avatar/12975/icon_CE2.JPG'
          link: 'claudio-aranzadi'
        },
        {
          name: "Alberto de Armas",
          short_name: "de Armas",
          position: "Médico y senador del PSOE. Fallecido",
          year: 1990,
          countries: "Guyana, Trinidad y Tobago, Venezuela y Surinam"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'alberto-de-armas-garcia'
        },
        {
          name: "Julián Santamaría",
          short_name: "Santamaría",
          position: "Excatedrático y exdirector del CIS",
          year: 1987,
          countries: "Estados Unidos"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'julian-santamaria-ossorio'
        },
        {
          name: "Fernando Alvarez de Miranda",
          short_name: "A. de Miranda",
          position: "Diputado, defensor del pueblo y presidente del Congreso por UCD",
          year: 1986,
          countries: "El Salvador"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'fernando-alvarez-de-miranda-torres'
        },
        {
          name: "Raúl Morodo",
          short_name: "Morodo",
          position: "Confundador del Partido Socialista Popular con Enrique Tierno Galván",
          year: 1983,
          countries: "Guyana, Surinam, Trinidad y Tobago y Venezuela"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'raul-morodo-leoncio'
        },
        {
          name: "Emilio Menéndez",
          short_name: "Menéndez",
          position: "Político, eurodiputado del PSOE",
          year: 1983,
          countries: "Italia, San Marino, Albania y Jordania"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'emilio-menendez-del-valle'
        },
        {
          name: "Eduardo Foncillas",
          short_name: "Foncillas",
          position: "Político del PSOE de Aragón",
          year: 1983,
          countries: "Alemania"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'eduardo-foncillas-casaus'
        },
        {
          name: "Jorge de Esteban",
          short_name: "de Esteban",
          position: "Catedrático de derecho constitucional",
          year: 1983,
          countries: "Italia"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'jorge-de-esteban-alonso'
        },
        {
          name: "Fernando Baeza",
          short_name: "Baeza",
          position: "Senador del PSOE",
          year: 1983,
          countries: "el Consejo de Europa"
          img: 'http://d2tvfs931h0imr.cloudfront.net/assets/avatar-tiny-7d22d37bcd7522dbf719291df1f334a3.png'
          link: 'fernando-baeza-martos'
        },
        {
          name: "Joan Raventós",
          short_name: "Raventós",
          position: "Fundador del PSC",
          year: 1983,
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
      $term.append '<div class="qm-ambassador-picture qm-ambassador-picture-term '+term.label+'" style="background-image: url('+term.img+'")"></div><h3>'+term.name+'</h3><p>'+term.description+'</p>'
      $items = $('<div class="qm-ambassadors-container"></div>')
      $items.append '<span class="qm-ambassadors-container-title">'+term.items.length+' embajadores sin carrera diplomática</span>'
      for item in term.items
        popoverContent = item.position+'<br/>Fue nombrado embajador en '+item.countries+'.'
        $item = $('<div class="qm-ambassador"></div>')
        $item.append '<a href="http://quienmanda.es/people/'+item.link+'" title="'+item.name+'" role="button" data-toggle="popover" data-placement="top" data-content="'+popoverContent+'"><div class="qm-ambassador-picture '+term.label+'" style="background-image: url('+item.img+'")"></div><h4>'+item.short_name+'</h4></a>'
        $items.append $item
      $term.append $items
      $el.append $term
    $('.qm-ambassador a').popover {trigger: 'hover', html: true}

  setupVisualization()
