<?php
defined('SYS_PATH') or die('No direct access allowed.');

/**
 * URL helper class.
 *
 * @package    Ko
 * @author     Ko Team, Eric 
 * @version    $Id: url.php 117 2009-10-10 07:12:11Z wangzh $
 * @copyright  (c) 2007-2009 Ko Team
 * @license    http://kophp.com/license.html
 */
class URL
{

    /**
     * Gets the base URL to the application. To include the current protocol,
     * use TRUE. To specify a protocol, provide the protocol as a string.
     *
     * @param   boolean         add index file
     * @param   boolean|string  add protocol and domain
     * @return  string
     */
    public static function base ($index = FALSE, $protocol = FALSE)
    {
        if ($protocol === TRUE) {
            // Use the current protocol
            $protocol = Request::$protocol;
        }
        // Start with the configured base URL
        $base_url = Ko::$base_url;
        if ($index === TRUE and ! empty(Ko::$index_file)) {
            // Add the index file to the URL
            $base_url .= Ko::$index_file . '/';
        }
        if (is_string($protocol)) {
            // Add the protocol and domain to the base URL
            $base_url = $protocol . '://' . $_SERVER['HTTP_HOST'] . $base_url;
        }
        return $base_url;
    }

    /**
     * Fetches an absolute site URL based on a URI segment.
     *
     * @param   string  site URI to convert
     * @param   string  non-default protocol
     * @return  string
     */
    public static function site ($uri = '', $protocol = FALSE)
    {
        // Get the path from the URI
        $path = trim(parse_url($uri, PHP_URL_PATH), '/');
        if ($query = parse_url($uri, PHP_URL_QUERY)) {
            // ?query=string
            $query = '?' . $query;
        }
        if ($fragment = parse_url($uri, PHP_URL_FRAGMENT)) {
            // #fragment
            $fragment = '#' . $fragment;
        }
        // Concat the URL
        return URL::base(TRUE, $protocol) . $path . $query . $fragment;
    }

    /**
     * Merges the current GET parameters with an array of new or overloaded
     * parameters and returns the resulting query string.
     *
     * @param   array   array of GET parameters
     * @return  string
     */
    public static function query (array $params = NULL)
    {
        if ($params === NULL) {
            // Use only the current parameters
            $params = $_GET;
        } else {
            // Merge the current and new parameters
            $params = array_merge($_GET, $params);
        }
        if (empty($params)) {
            // No query parameters
            return '';
        }
        return '?' . http_build_query($params, '', '&');
    }

    /**
     * Convert a phrase to a URL-safe title. Note that non-ASCII characters
     * should be transliterated before using this function.
     *
     * @param   string  phrase to convert
     * @param   string  word separator (- or _)
     * @return  string
     */
    public static function title ($title, $separator = '-')
    {
        $separator = ($separator === '-') ? '-' : '_';
        // Remove all characters that are not the separator, a-z, 0-9, or whitespace
        $title = preg_replace('/[^' . $separator . 'a-z0-9\s]+/', '', strtolower($title));
        // Replace all separator characters and whitespace by a single separator
        $title = preg_replace('/[' . $separator . '\s]+/', $separator, $title);
        // Trim separators from the beginning and end
        return trim($title, $separator);
    }
} // End url