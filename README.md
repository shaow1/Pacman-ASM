# AssemblyLanguage
Pacman

No Ghosts

"blinky yellow" -thanks durga

dots eat dots

Notes:
2s arrays (have to figure that out but im assuming it would work as a single array you access as <1stindex>* <lenthOfEachColumn>  + <2ndindex>)

Psuedo-Code:

	levelArray = 2d array of walls and pacman and dots
	curPos = where pacman is

	until(dots == 0){
	
		startCounter()
	
		until(counter == 1 sec){
			read keyboardInput	
		}
	
		if (keyboardInput){
			nextPos = curPos+directionOfKeyboardInput
			nextPosValue = levelarray[nextPos]
	
			if (nextPosValue == wall){
				break
			}
			else if (nextPosValue == dot){
				replace pos in array with pacman
				score++
			}
			else if (nextPosValue == free){
				replace pos in array with pacman
			}
	
			updatescreen()
	
		}
	}
