local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

cAPI = Proxy.getInterface('cAPI')
API = Tunnel.getInterface('API')

menu1 = {
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.PARENTS,
        icon= "fas fa-user-friends",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.FATHER_FACE,
                min= 0,
                max= 20,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.FATHER_COLOR,
                min= 0,
                max= 20,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.MOTHER_FACE,
                min= 21,
                max= 45,
                value= 21
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.MOTHER_COLOR,
                min= 0,
                max= 20,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.PREDOMINANT_FACE,
                min= 0.0,
                max= 1.0,
                step= 0.05,
                value= 0.5
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.PREDOMINANT_COLOR,
                min= 0.0,
                max= 1.0,
                step= 0.05,
                value= 0.5
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYES,
        icon= "fas fa-eye",
        options = {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYES_SIZE,
                min= -1,
                max= 1,
                step= 0.05,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYES_COLOR,
                min= 0,
                max= 31,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYEBROWN,
                min= 0,
                max= 33,
                value= 0
            },
            {
                show= false,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYEBROWN_SIZE,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0.0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYEBROWN_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYEBROWN_HEIGHT,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0.0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.EYEBROWN_WIDTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0.0
            },
        }
    }, 
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE,
        icon= "medicinebody-big-nose",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_HEIGHT,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_WIDTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_LENGTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_CAVITY,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_TIP,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NOSE_CURVATURE,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN,
        icon= "bodyandfitness-077-chin",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN_LENGTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN_POSITION,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN_WIDTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHIN_FORM,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.JAW_WIDTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.JAW_HEIGHT,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHEEK,
        icon= "fas fa-user-friends",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHEEK_HEIGHT,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHEEK_WIDTH,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.CHEEK_SIZE,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.MOUTH,
        icon= "medicinebody-woman-lips",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.LIPS,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            }, 
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NECK,
        icon= "medicinebody-human-neck",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu1.NECK_SIZE,
                min= -1,
                max= 0.99,
                step= 0.01,
                value= 0
            }, 
        }
    },
}

menu2 = {
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.FACE_MARKS,
        icon= "fontUser-024-face-scan",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.ASPECTS,
                min= -1,
                max= 11,
                value= -1
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.SKIN,
                min= -1,
                max= 10,
                value= -1
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.FRECKLES,
                min= -1,
                max= 17,
                value= -1
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.HAIR,
        icon= "medicinebody-men-hair",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.HAIR,
                min= 0,
                max= 38,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.HAIR_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.HAIR_HIGHLIGHTS,
                min= 0,
                max= 33,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BEARDS,
        icon= "medicinebody-man-with-beard",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BEARDS,
                min= -1,
                max= 28,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BEARDS_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP,
        icon= "fontMakeUp-women-lipstick",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP_BLUSH,
                min= -1,
                max= 7,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP_BLUSH_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP_LIPSTICK,
                min= -1,
                max= 9,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP_LIPSTICK_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.MAKEUP,
                min= -1,
                max= 71,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.OLD_AGE,
        icon= "fontOldAge-014-old",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.WRINKLES,
                min= -1,
                max= 14,
                value= -1
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.DEGREE_WRINKLES,
                min= -1,
                max= 14,
                value= -1
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.TORSO,
        icon= "bodyandfitness-066-body",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.TORSO_FUR,
                min= -1,
                max= 16,
                value= -1
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.TORSO_FUR_COLOR,
                min= 0,
                max= 63,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BODY,
        icon= "fas fa-male",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BODY_MARKS,
                min= -1,
                max= 11,
                value= -1
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu2.BODY_MARKS_2,
                min= 0,
                max= 1,
                value= 0
            },
        }
    }
}

menu3 = {
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.NAME,
        icon= "fas fa-id-card",
        options= {
            {
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.NAME_SURNAME,
                value= cAPI.getUILanguage(GetCurrentResourceName()).menu3.NAME_VALUE,
                type= 'text'
            },
            {
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.AGE,
                value= "18",
                type= 'text'
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.JACKET,
        icon= "clothes-009-tuxedo",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.JACKET_COAT,
                min= -1,
                max= 331,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.JACKET_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.SHIRT,
        icon= "clothes-017-shirt-5",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.T_SHIRT,
                min= -1,
                max= 164,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.T_SHIRT_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.TORSO,
        icon= "clothes-003-shirt-7",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.TORSO,
                min= -1,
                max= 168,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.TORSO_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.LEGS,
        icon= "clothes-025-trousers",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.LEGS,
                min= -1,
                max= 126,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.LEGS_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.FOOTS,
        icon= "clothes-031-shoe",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.FOOTS,
                min= -1,
                max= 95,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.FOOTS_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    },
    {
        name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.ACESSORY,
        icon= "clothes-047-hanger",
        options= {
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.ACESSORY,
                min= -1,
                max= 135,
                value= 0
            },
            {
                show= true,
                name= cAPI.getUILanguage(GetCurrentResourceName()).menu3.ACESSORY_TEXTURE,
                min= 0,
                max= 3,
                value= 0
            },
        }
    }
}