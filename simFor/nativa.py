# Demonstracao para entender a regulacao florestal

# Build a simple forest simulator
import simplegui
import random

# Imagem
forest = simplegui.load_image('https://i0.wp.com/www.permaculture.org.au/images/Forest-Succession_profile_chart.jpg')

# Variáveis iniciais
CANVAS_X = 600
CANVAS_Y = 500
CANVAS_YFULL = 600

FLORESTA = []
COLHEITA = 0.0
ANO = 2018
AREA = 10
SIZE = (50, 50)
colunas = range(SIZE[0]/2, CANVAS_X, SIZE[0])
linhas = range(SIZE[1]/2, CANVAS_Y, SIZE[1])
POSX = []
POSY = []
VALOR = 0
OLD = 0
# Define classe talhao

class talhao:
    def __init__(self, tempo):
        self.tempo = tempo
        if int(self.tempo) < 2:
            self.estado = "graminea"
        elif int(self.tempo) < 5:
            self.estado = "plantula"
        elif int(self.tempo) < 10:
            self.estado = "arbusto"
        elif int(self.tempo) < 30:
            self.estado = "pioneira"
        else:
            self.estado = "madura"
        #print self.tempo
        #print self.estado
    def __str__(self):
        return str(self.tempo)
      
    def tempo(self):
        return self.tempo
    
    def estado(self):
        return self.estado
    
    def dinamica(self): #handler_time
        if random.random() < 0.995:
            self.tempo = int(self.tempo) + 1
            if int(self.tempo) < 2:
                self.estado = "graminea"
            elif int(self.tempo) < 5:
                self.estado = "plantula"
            elif int(self.tempo) < 10:
                self.estado = "arbusto"
            elif int(self.tempo) < 30:
                self.estado = "pioneira"
            else:
                self.estado = "madura"
        else:
            self.tempo = 2
            self.estado = "plantula"

            
    def colheita(self, area): #handler_mouse
        if self.estado == "madura":
            lower = 15 * int(area)
            upper = 30 * int(area)
            range_width = upper - lower
            volume = random.random() * range_width + lower
            self.tempo = 10
            self.estado = "pioneira"
        elif self.estado == "pioneira":
            lower = 5 * int(area)
            upper = 15 * int(area)
            range_width = upper - lower
            volume = random.random() * range_width + lower
            self.tempo = 5
            self.estado = "arbusto"
        else:
            volume = 0
        return volume
    
    def draw(self, canvas, pos, size):
        if self.estado == "graminea":
            canvas.draw_image(forest, (70, 155), (50, 100), pos, size)
        elif self.estado == "plantula":
            canvas.draw_image(forest, (170, 150), (50, 100), pos, size)
        elif self.estado == "arbusto":
            canvas.draw_image(forest, (270, 145), (50, 100), pos, size)
        elif self.estado == "pioneira":
            canvas.draw_image(forest, (360, 125), (50, 100), pos, size)
        elif self.estado == "madura":
            canvas.draw_image(forest, (446, 104), (50, 108), pos, size)


# Inicializa o jogo

def reset():
    global VALOR, OLD
    for c in colunas:
        for l in linhas:
            FLORESTA.append(talhao(random.randrange(0, 500)))
            POSX.append(c)
            POSY.append(l)
    for i in range(len(FLORESTA)):
        #print i
        FLORESTA[i].dinamica()
        VALOR += FLORESTA[i].tempo
        OLD = VALOR
    #print len(POSX)
    #print len(POSY)
    #print LAND, type(LAND)
    #print FLORESTA[1], POSX[1], POSY[1]

# Controlador do tempo

def timer_handler():
    global ANO, COLHEITA, VALOR, OLD  
    ANO += 1
    COLHEITA = 0
    OLD = VALOR
    VALOR = 0
    #print ANO
    #print len(FLORESTA)
    for i in range(len(FLORESTA)):
        #print i
        FLORESTA[i].dinamica()
        VALOR += FLORESTA[i].tempo


# Controlador do mouse

def mouse_handler(position):
    global COLHEITA, AREA
    COLHEITA += round(FLORESTA[((position[0]//SIZE[0]) * (CANVAS_Y / SIZE[0]) + position[1]//SIZE[1])].colheita(AREA), 1)
    
# Criar Canvas

def draw(canvas):
    for i in range(len(FLORESTA)):
        #print i
        FLORESTA[i].draw(canvas, (POSX[i], POSY[i]), SIZE)
    canvas.draw_text('Ano: ' + str(ANO), (10, CANVAS_Y + 40), 15, 'Black')
    canvas.draw_text('Tempo transcorrido: ' + str(ANO - 2018), (10, CANVAS_Y + 75), 15, 'Black')
    canvas.draw_text('Colheira no ano: ' + str(COLHEITA), (100, CANVAS_Y + 40), 15, 'Black')
    canvas.draw_text('Valor: ' + str(VALOR), (350, CANVAS_Y + 40), 15, 'Black')
    canvas.draw_text('Loss-value: ' + str(VALOR - OLD), (350, CANVAS_Y + 75), 15, 'Black')
    canvas.draw_text('Area: ' + str(len(FLORESTA) * AREA), (450, CANVAS_Y + 40), 15, 'Black')

# Create a frame and assign callbacks to event handlers
frame = simplegui.create_frame("4stSIM", CANVAS_X, CANVAS_YFULL)
frame.set_canvas_background("White")
frame.set_mouseclick_handler(mouse_handler)
frame.set_draw_handler(draw)

frame.add_label("Bem vindo ao SimFOR!")
frame.add_label("")
frame.add_label("1. Clique sobre o desenho para cortar a floresta.")
frame.add_label("2. Cada clique equivale a exploracao de 10 ha.")
frame.add_label("3. O corte de uma floresta madura leva a um estagio de pioneira")
frame.add_label("4. O corte de uma floresta pioneira leva a um estagio de arbusto")
frame.add_label("5. Nao e permitido cortar floresta em estagio inferior a pioneira")


reset()

timer = simplegui.create_timer(10000, timer_handler)
timer.start()
frame.start()
