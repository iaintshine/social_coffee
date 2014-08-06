/**
 * This file contains the protocol interface for operations to query
 * friends and users relationships.
 */

//============================= Versioning ==================================

/**
 * Major version.
 */
const i16 SOCIAL_COFFEE_VERSION_MAJOR = 1

/**
 * Minor version.
 */
const i16 SOCIAL_COFFEE_VERSION_MINOR = 0

//============================= Exceptions ==================================

/**
 *
 */
exception SocialException {
    1: required string message
}

//============================= Types ==================================

/**
 * Every resource is assigned a unique numeric identifier which
 * will not change for the life of the resource.
 */
typedef i32 ID

//============================= Service ==================================

/**
 * Service: SocialCoffeeService
 */
service SocialCoffeeService {

    //============================= Query Operations ==================================

    list<ID> get_friends(1: ID id) throws (1: SocialException ex)

    //============================= Friendship Operations ==================================

    void create_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)

    void remove_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)
    
}