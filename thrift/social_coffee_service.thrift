/**
 * This file contains the protocol interface for operations to query
 * friends and users relationships.
 */

namespace * com.github.iaintshine.socialcoffee.thrift
namespace js SocialCoffee.Thrift

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
 * This exception is thrown when a call fails due to input data validation or 
 * any internall error occurs e.g. database connection refused.
 *
 * message: The string message indicating the type of error that occurred and the reason why it occurred.  
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

    /**
     * Returns a list of user's friends with provided ID.
     *
     * @param id
     *      The ID of the user for whom the list of the friends should be retrieved.
     *
     * @return
     *      The list of user's friends IDs. If user has no friends empty list is returned.
     *
     * @throws SocialException <ul>
     *  <li>if ID is null</li>
     *  <li>if ID is not a number<li>
     *  <li>if ID is a non positive number</li>
     *  <li>if internall error occurs e.g. connection to a database could not be established</li>
     * </ul>
     */
    list<ID> get_friends(1: ID id) throws (1: SocialException ex)

    //============================= Friendship Operations ==================================

    /**
     * Asks the service to make a new multual friendship relationship between users with IDs usera and userb.
     * It's an idempotent operation so it can be called multiple times.
     *
     * @param usera
     *      The ID of the user A.
     * 
     * @param userb
     *      The ID of the user B. 
     *
     * @return
     *      Boolean value indicating whether the operation created a new relationship or relationship already existed.
     *      "true" if operation created a new friendship relationship, "false" otherwise.
     * 
     * @throws SocialException <ul>
     *  <li>if any of IDs is null</li>
     *  <li>if any of IDs is not a number<li>
     *  <li>if any of IDs is a non positive number</li>
     *  <li>if both of IDs are equal</li>
     *  <li>if internall error occurs e.g. connection to a database could not be established</li>
     * </ul>
     */
    bool create_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)

    /**
     * Asks the service to remove a new friendship relationship between users with IDs usera and userb.
     * It's an idempotent operation so it can be called multiple times.
     *
     * @param usera
     *      The ID of the user A.
     * 
     * @param userb
     *      The ID of the user B. 
     *
     * @return
     *      Boolean value indicating whether the operation removed an already existed relationship or operation did nothing.
     *      "true" if operation removed an already existed friendship relationship, "false" otherwise.
     * 
     * @throws SocialException <ul>
     *  <li>if any of IDs is null</li>
     *  <li>if any of IDs is not a number<li>
     *  <li>if any of IDs is a non positive number</li>
     *  <li>if both of IDs are equal</li>
     *  <li>if internall error occurs e.g. connection to a database could not be established</li>
     * </ul>
     */
    bool remove_friendship(1: ID usera, 2: ID userb) throws (1: SocialException ex)
    
}