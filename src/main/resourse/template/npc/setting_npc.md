# Setting of NPC

## Globals

- effects: ARROW_PARTICLES, RABBIT_JUMP, DEATH, HURT, SHEEP_EAT, WOLF_HEARTS, WOLF_SHAKE, WOLF_SMOKE, IRON_GOLEM_ROSE, VILLAGER_HEART, VILLAGER_ANGRY, VILLAGER_HAPPY, WITCH_MAGIC, ZOMBIE_TRANSFORM, FIREWORK_EXPLODE, LOVE_HEARTS, SQUID_ROTATE, ENTITY_POOF, GUARDIAN_TARGET, SHIELD_BLOCK, SHIELD_BREAK, ARMOR_STAND_HIT, THORNS_HURT, IRON_GOLEM_SHEATH, TOTEM_RESURRECT, HURT_DROWN, HURT_EXPLOSION, GLOWING
- gravity: boolean
- invulnerable: boolean
- location: local
- on fire: boolean
- ride: UUID
- silent: boolean
- name: string
- visible name: boolean
- velocity: vector
- type: AREA_EFFECT_CLOUD, ARMOR_STAND, ARROW, BAT, BEE, BLAZE, BOAT, CAT, CAVE_SPIDER, CHICKEN, COD, COW, CREEPER, DOLPHIN, DRAGON_FIREBALL, DROPPED_ITEM, DROWNED, DONKEY, EGG, ELDER_GUARDIAN, ENDERMAN, ENDERMITE, ENDER_CRYSTAL, ENDER_DRAGON, ENDER_EYE, ENDER_PEARL, EVOKER, EVOKER_FANGS, EXPERIENCE_ORB, FALLING_BLOCK, FIREBALL, FIREWORK, FOX, GHAST, GIANT, GUARDIAN, HORSE, HUSK, ILLUSIONER, IRON_GOLEM, ITEM_FRAME, LLAMA, LLAMA_SPIT, LEASH_HITCH, LIGHTNING, MAGMA_CUBE, MINECART, MINECART_CHEST, MINECART_COMMAND, MINECART_FURNACE, MINECART_HOPPER, MINECART_MOB_SPAWNER, MINECART_TNT, MULE, MUSHROOM_COW, OCELOT, PAINTING, PANDA, PARROT, PHANTOM, PIG, PIG_ZOMBIE, PILLAGER, POLAR_BEAR, PRIMED_TNT, PUFFERFISH, RABBIT, RAVAGER, SALMON, SHEEP, SILVERFISH, SKELETON, SHULKER, SHULKER_BULLET, SKELETON_HORSE, SLIME, SMALL_FIREBALL, SNOWBALL, SNOWMAN, SQUID, SPECTRAL_ARROW, SPIDER, SPLASH_POTION, STRAY, THROWN_EXP_BOTTLE, TRADER_LLAMA, TRIDENT, TROPICAL_FISH, TURTLE, VEX, VILLAGER, VINDICATOR, WANDERING_TRADER, WITCH, WITHER, WITHER_SKELETON, WITHER_SKULL, WOLF, ZOMBIE, ZOMBIE_HORSE, ZOMBIE_VILLAGER
- pickup items: boolean
- ai: boolean
- air: int
- breedable: boolean
- gliding: boolean
- health: int in [0, 100]
- immunity: int
- max_air: int
- persistence: boolean
- equipment_droprates: \*
- leashholder: uuid
- max_health: double
- collidable: boolean
- mob_effect: \*
- equipment: \*
- owner: string
- target: null | uuid

## Spec

- AREA_EFFECT_CLOUD

  - color: The color array of the particle, if applicable (eg. SPELL_MOB particle type).
  - duration: int
  - durationonuse: The amount the duration will change when the effects are applied.
  - particle: TSMOKE_NORMAL, ENCHANTMENT_TABLE, REDSTONE, SNOW_SHOVEL, BUBBLE_COLUMN_UP, SPELL_MOB, CAMPFIRE_SIGNAL_SMOKE, BLOCK_DUST, FALLING_HONEY, SWEEP_ATTACK, WATER_SPLASH, LANDING_LAVA, SLIME, FALLING_LAVA, DRAGON_BREATH, CURRENT_DOWN, DRIPPING_HONEY, ITEM_CRACK, FALLING_DUST, SNEEZE, WATER_BUBBLE, FLASH, VILLAGER_ANGRY, HEART, LANDING_HONEY, END_ROD, FALLING_NECTAR, CRIT_MAGIC, SUSPENDED, WATER_DROP, SPELL, FALLING_WATER, SPELL_INSTANT, LAVA, VILLAGER_HAPPY, SQUID_INK, CRIT, CLOUD, BUBBLE_POP, COMPOSTER, NAUTILUS, EXPLOSION_LARGE, TOWN_AURA, SUSPENDED_DEPTH, CAMPFIRE_COSY_SMOKE, NOTE, SNOWBALL, SPELL_MOB_AMBIENT, DAMAGE_INDICATOR, SMOKE_LARGE, TOTEM, BARRIER, EXPLOSION_NORMAL, FLAME, SPIT, PORTAL, MOB_APPEARANCE, DOLPHIN, SPELL_WITCH, DRIP_WATER, EXPLOSION_HUGE, WATER_WAKE, UNKNOWN, FIREWORKS_SPARK, DRIP_LAVA, BLOCK_CRACK
  - potionmeta: An array of potion effect arrays for the cloud.
  - radius: double
  - radiusonuse: double
  - radiuspertick: int
  - reapplicationdelay: int
  - source: UUID | local | null
  - waittime: int

- ARROW

  - critical: boolean
  - knockback: double
  - damage: double
  - potionmeta: An associative array with a "base" potion array and a "potions" array of effect arrays for a tipped arrow.

- ARMOR_STAND

  - arms: boolean
  - baseplate: boolean
  - gravity: boolean
  - marker: boolean
  - small: boolean
  - visible: boolean
  - poses: \[part_of_body : \[x, y, z\], ...\]

- BEE

  - anger: boolean
  - flowerlocation: \[flowers\]
  - hivelocation: \[location of the bee's hive\]
  - nector: boolean
  - stung: boolean

- BOAT

  - type: ACACIA, BIRCH, DARK_OAK, JUNGLE, OAK, SPRUCE

- CAT

  - type: ALL_BLACK, BLACK, BRITISH_SHORTHAIR, CALICO, JELLIE, PERSIAN, RAGDOLL, RED, SIAMESE, TABBY, WHITE
  - sitting: boolean

- CREEPER

  - powered: boolean
  - maxfuseticks: int
  - explosionradius: int

- DONKEY, MULE

  - chest: boolean
  - domestication: int
  - jump: double [1.0, 2.0]
  - maxdomestication: int
  - saddle: An item pertaining to the saddle a horse has put on. Can be anything.

- DROPPED_ITEM

  - itemstack: An array representing the item.
  - pickupdelay: int

- ENDER_CRYSTAL

  - base: boolean
  - beamtarget: local

- ENDER_DRAGON

  - phase: BREATH_ATTACK, CHARGE_PLAYER, CIRCLING, DYING, FLY_TO_PORTAL, HOVER, LAND_ON_PORTAL, LEAVE_PORTAL, ROAR_BEFORE_ATTACK, SEARCH_FOR_BREATH_ATTACK_TARGET, STRAFING

- ENDER_EYE

  - despawnticks: int
  - drop: boolean
  - target: local

- ENDERMAN

  - carried: block

- EVOKER_FANGS

  - source: UUID | null

- EXPERIENCE_ORB

  - amount: int

- FALLING_BLOCK

  - block: The falling block. Not editable.
  - dropitem: item
  - damage: double

- FIREBALL, DRAGON_FIREBALL, SMALL_FIREBALL

  - direction: The direction the fireball is heading toward.

- FIREWORK

  - strength: int
  - effects: An array of firework effect arrays. (see launch_firework)

- FOX

  - sitting: boolean
  - crouching: boolean
  - type: RED, SNOW)

- HORSE

  - armor: item
  - color: BLACK, BROWN, CHESTNUT, CREAMY, DARK_BROWN, GRAY, WHITE
  - domestication: int
  - jump: double [1.0, 2.0].
  - maxdomestication: int
  - saddle: item
  - style: NONE, SOCKS, WHITEFIELD, WHITE_DOTS, BLACK_DOTS

- HUSK

  - baby: boolean.

- IRON_GOLEM

  - playercreated: boolean.

- ITEM_FRAME

  - item: item
  - rotation: CLOCKWISE, CLOCKWISE_135, CLOCKWISE_45, COUNTER_CLOCKWISE, COUNTER_CLOCKWISE_45, FLIPPED, FLIPPED_45, NONE

- LLAMA, TRADER_LLAMA

  - chest: boolean
  - domestication: int
  - maxdomestication: int
  - color: CREAMY, WHITE, BROWN, GRAY
  - saddle: item

- LIGHTNING

  - effect: boolean

- MAGMA_CUBE

  - size: int

- MINECART, MINECART_FURNACE, MINECART_HOPPER, MINECART_MOB_SPAWNER,
MINECART_TNT

  - block: block
  - offset: int

- MINECART_COMMAND

  - command: string
  - customname: string
  - block: block
  - offset: int

- MUSHROOM_COW

  - type: TRED, BROWN

- OCELOT

  - sitting: boolean
  - type: BLACK_CAT, RED_CAT, SIAMESE_CAT, WILD_OCELOT)

- PAINTING

  - type: KEBAB, AZTEC, ALBAN, AZTEC2, BOMB, PLANT, WASTELAND, POOL, COURBET, SEA, SUNSET, CREEBET, WANDERER, GRAHAM, MATCH, BUST, STAGE, VOID, SKULL_AND_ROSES, WITHER, FIGHTERS, POINTER, PIGSCENE, BURNING_SKULL, SKELETON, DONKEY_KONG

- PANDA

  - maingene: AGGRESSIVE, BROWN, LAZY, NORMAL, PLAYFUL, WEAK, WORRIED
  - hiddengene: boolean

- PARROT

  - sitting: boolean
  - type: RED, BLUE, GREEN, CYAN, GRAY

- PHANTOM

  - size: int [0, 64]

- PIG

  - saddled: boolean

- PIG_ZOMBIE

  - anger: int
  - angry: boolean
  - baby: boolean

- PRIMED_TNT

  - fuseticks: int
  - source: The source of the primed TNT. Not editable.

- RABBIT

  - type: BROWN, WHITE, BLACK, BLACK_AND_WHITE, GOLD, SALT_AND_PEPPER, THE_KILLER_BUNNY

- SHEEP

  - color: TWHITE, ORANGE, MAGENTA, LIGHT_BLUE, YELLOW, LIME, PINK, GRAY, LIGHT_GRAY, CYAN, PURPLE, BLUE, BROWN, GREEN, RED, BLACK
  - sheared: boolean

- SHULKER

  - color: WHITE, ORANGE, MAGENTA, LIGHT_BLUE, YELLOW, LIME, PINK, GRAY, LIGHT_GRAY, CYAN, PURPLE, BLUE, BROWN, GREEN, RED, BLACK

- SHULKER_BULLET

  - target: UUID | id

- SKELETON_HORSE, ZOMBIE_HORSE

  - domestication: int
  - jump: double [1.0, 2.0]
  - maxdomestication: int
  - saddle: item

- SLIME

  - size: int

- SNOWMAN

  - derp: boolean

- SPECTRAL_ARROW

  - critical: Iboolean
  - knockback: double
  - damage: double
  - glowingticks: int

- SPLASH_POTION

  - item: item

- TRIDENT

  - critical: boolean
  - knockback: double
  - damage: double

- TROPICAL_FISH

  - color: WHITE, ORANGE, MAGENTA, LIGHT_BLUE, YELLOW, LIME, PINK, GRAY, LIGHT_GRAY, CYAN, PURPLE, BLUE, BROWN, GREEN, RED, BLACK
  - patterncolor: The color of the pattern on the fish.
  - pattern: KOB, SUNSTREAK, SNOOPER, DASHER, BRINELY, SPOTTY, FLOPPER, STRIPEY, GLITTER, BLOCKFISH, BETTY, CLAYFISH

- VEX

  - charging: boolean

- VILLAGER

  - profession: TBUTCHER, FARMER, LIBRARIAN, NITWIT, ARMORER, CARTOGRAPHER, CLERIC, FISHERMAN, FLETCHER, LEATHERWORKER, MASON, NONE, SHEPHERD, TOOLSMITH, WEAPONSMITH

- WITHER_SKULL

  - charged: boolean
  - direction: vector

- WOLF

  - angry: boolean
  - color: WHITE, ORANGE, MAGENTA, LIGHT_BLUE, YELLOW, LIME, PINK, GRAY, LIGHT_GRAY, CYAN, PURPLE, BLUE, BROWN, GREEN, RED, BLACK
  - sitting: boolean

- ZOMBIE, HUSK, ZOMBIE_VILLAGER, DROWNED

  - baby: boolean

- ZOMBIE_VILLAGER

  - baby: boolean
  - profession: TBUTCHER, FARMER, LIBRARIAN, NITWIT, ARMORER, CARTOGRAPHER, CLERIC, FISHERMAN, FLETCHER, LEATHERWORKER, MASON, NONE, SHEPHERD, TOOLSMITH, WEAPONSMITH
