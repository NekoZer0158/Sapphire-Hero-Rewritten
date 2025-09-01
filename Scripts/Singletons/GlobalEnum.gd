extends Node

## ONLY ENUM HERE

## PLAYER - игрок [br]
## COMRADE - союзник (добавлено с заделом на ремейк сиквела) [br]
## ENEMY - враг
enum BodyTypes {PLAYER,COMRADE,ENEMY}
##IDLE - ходит туда сюда на небольшой территории[br]
##ATTACKING - атакует игрока[br]
##WORRIED - начинать бродить по более обширной территории, чем прежде, ведь знает, что игрок рядом
enum EnemyState {IDLE,ATTACKING,WORRIED}
