# CodeSkulptor runs Python programs in your browser.
# Click the upper left button to run this simple demo.

# CodeSkulptor runs in Chrome 18+, Firefox 11+, and Safari 6+.
# Some features may work in other browsers, but do not expect
# full functionality.  It does NOT run in Internet Explorer.

# Build a simple forest simulator
import simplegui
import random

# Carregar imagem árvore
TREE_SIZE = (215, 203)
tree_image = simplegui.load_image('http://orig11.deviantart.net/592e/f/2009/357/8/2/apple_tree_growth_stages_by_eatmemtfckr.png')
industria_image = simplegui.load_image('https://cdn4.iconfinder.com/data/icons/REALVISTA/accounting/png/400/industry.png')
STUMP_SIZE = (498, 492)
stump_image = simplegui.load_image('http://www.clipartbest.com/cliparts/niX/qjn/niXqjn5iB.png')
TREE2_SIZE = (38, 52)
tree2_image = simplegui.load_image('http://images.clipartlogo.com/files/images/36/367485/four-seasons-tree-icons_t.jpg')
month = 0

# Variáveis globais
CANVAS_X = 600
CANVAS_Y = 600
CANVAS_Yutil = 400

IN_PLAY = True
AREA_PIXEL = 50
DESENVOLVIMENTO = ('ESPERANDO', 'PLANTADO')
IDADE = ('0', '1', '2', '3', '4', '5', '6')
PRODUCAO = {'0':0, '1':30, '2':80, '3':130, '4':250, '5': 380, '6':420}

colheita = 0
status = 'Parada'
povoamento = []
ind = []


# Define classe árvore
class tree:
    def __init__(self, estadio, idade):
        self.estadio = estadio
        if self.estadio == 'ESPERANDO':
            self.idade = '0'
        else:    
            self.idade = str(idade)

    def __str__(self):
        return self.estadio + self.idade

    def get_estadio(self):
        return self.estadio
    
    def get_idade(self):
        return self.idade
    
    def growth(self):
        if self.estadio == 'PLANTADO':
            if int(self.idade) >=6:
                self.idade = '6'
            else:
                self.idade = str(int(self.idade) + 1)
        else:
            self.idade = '0'

    def colheita(self):
        if int(self.idade) > 4 or int(self.idade) == 0:
            if int(self.idade) > 6:
                volume = PRODUCAO['6'] * AREA_PIXEL
            else:
                volume = PRODUCAO[self.idade] * AREA_PIXEL

            self.idade = '0'
            self.estadio = 'PLANTADO'
        
        else:
            volume = 0
            
        return volume
    
    def draw(self, canvas, pos):
        #tree_loc = (130 + IDADE.index(self.idade) * 215, 140)
        #canvas.draw_image(tree_images, tree_loc, IMAGE_SIZE, (pos[0], pos[1]), (50, 50))
        
        if self.estadio == 'ESPERANDO':
            canvas.draw_image(tree_image, (130, 140), TREE_SIZE, (pos[0], pos[1]), (50, 50))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 0:
            canvas.draw_image(tree2_image, (171.5, 26), TREE2_SIZE, (pos[0], pos[1]), (10, 10))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 1:
            canvas.draw_image(tree2_image, (171.5, 26), TREE2_SIZE, (pos[0], pos[1]), (20, 20))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 2:    
            canvas.draw_image(tree2_image, (119, 26), TREE2_SIZE, (pos[0], pos[1]), (20, 20))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 3:    
            canvas.draw_image(tree2_image, (119, 26), TREE2_SIZE, (pos[0], pos[1]), (30, 30))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 4:    
            canvas.draw_image(tree2_image, (68, 26), TREE2_SIZE, (pos[0], pos[1]), (30, 30))
        elif self.estadio == 'PLANTADO' and int(self.idade) == 5:    
            canvas.draw_image(tree2_image, (68, 26), TREE2_SIZE, (pos[0], pos[1]), (40, 40))
        elif self.estadio == 'PLANTADO' and int(self.idade) >= 6:    
            canvas.draw_image(tree2_image, (68, 26), TREE2_SIZE, (pos[0], pos[1]), (50, 50))

class industria:
    def __init__(self, demanda):
        self.demanda = demanda
        
    def __str__(self):
        return str(self.demanda)
    
    def operacao(self):
        global colheita, status
        
        if colheita > self.demanda:
            status = '100%'
            colheita = colheita - self.demanda
        elif colheita > 0:
            status = str(round(float(colheita)/self.demanda, 2)*100.) + '%'
            colheita = colheita - colheita
        else:
            status = 'Parada'
    
    def draw(self, canvas, pos):
        canvas.draw_image(industria_image, (200, 200), (400, 400), (pos[0], pos[1]), (200, 200))

def reset():
    ind.append(industria(200000))
    
    p = 0
    while p < (CANVAS_X/50) * (CANVAS_Yutil/50):
        povoamento.append(tree(DESENVOLVIMENTO[random.randrange(0, 2)], 
                               IDADE[random.randrange(0, 7)]))
        p += 1
 
# Controlador do tempo
def timer_handler():
    global month, colheita, status
    
    month += 1

    for p in range((CANVAS_X/50) * (CANVAS_Yutil/50)):    
        povoamento[p].growth()
        
    ind[0].operacao()
    
# Controlador do mouse 
def mouse_handler(position):
    global colheita
    colheita += povoamento[(position[1]/50)*12 + position[0]/50].colheita()
    
# Handler to draw on canvas
def draw(canvas):
    l = 0
    for p in range((CANVAS_X/50) * (CANVAS_Yutil/50)):
        povoamento[p].draw(canvas, (25 + (50 * (p%12)), (25 + (50 * l))))
        if (p + 1)%12 == 0:
            l += 1
    ind[0].draw(canvas, (500, 500))
    canvas.draw_text('Idade: '+ str(month) + ' anos', (20, 500), 20, 'Black')
    canvas.draw_text('Estoque em campo: '+ str(colheita) + ' m3', (20, 530), 20, 'Green')
    canvas.draw_text('Demanda de ' + str(ind[0]) + ' m3 : '+ str(status), (20, 560), 20, 'Red')

# Create a frame and assign callbacks to event handlers
frame = simplegui.create_frame("FAZENDA", CANVAS_X, CANVAS_Y)
frame.set_canvas_background("White")
frame.set_mouseclick_handler(mouse_handler)
frame.set_draw_handler(draw)

#Inicializar
reset()

# Start the frame animation
timer = simplegui.create_timer(10000, timer_handler)
timer.start()
frame.start()
