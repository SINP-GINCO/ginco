package fr.ifn.ogam.common.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Date;

/**
 * Simple Cache Object. No synchronization is done, this cache should be used for read-only tables. Cache can be simple, size-limited and/or time-limited.
 */
public class LocalCache {

	// Le container de données
	private Map<Object, Object> cachemap;

	// La taille max
	private int maxSize = -1;

	// La limitation du temps
	private boolean timeLimited = false;
	private Date lastUpdateDate = null;
	private long maxLifeTime;

	/**
	 * LocalCache constructor.
	 */
	private LocalCache() {
		super();
		cachemap = new HashMap<Object, Object>();
	}

	/**
	 * LocalCache constructor.
	 * 
	 * This cache is a size-limited cache. When the size limit is exceeded the cache is emptied.
	 * 
	 * @param aMaxSize
	 *            max size.
	 */
	private LocalCache(int aMaxSize) {
		super();
		cachemap = new HashMap<Object, Object>(aMaxSize);
		maxSize = aMaxSize;
	}

	/**
	 * LocalCache Factory.
	 * 
	 * @return a cache
	 */
	public static LocalCache getLocalCache() {
		return new LocalCache();
	}

	/**
	 * LocalCache Factory. When the size limit is exceeded the cache is emptied.
	 * 
	 * @param maxCapacity
	 *            max size.
	 * @return a size limited cache
	 */
	public static LocalCache getSizeLimitedLocalCache(int aMaxSize) {
		return new LocalCache(aMaxSize);
	}

	/**
	 * LocalCache Factory.
	 * 
	 * Return a local cache with a time limit. When the time limit is exceeded the cache is emptied.
	 * 
	 * @param aMaxLifeTimeInMs
	 *            a time limit for the cache
	 * @return a time limited cache
	 */
	public static LocalCache getTimeLimitedLocalCache(int aMaxLifeTimeInMs) {
		LocalCache localCache = new LocalCache();
		localCache.setTimeLimited(true);
		localCache.setMaxLifeTime(aMaxLifeTimeInMs);
		return localCache;
	}

	/**
	 * LocalCache Factory.
	 * 
	 * Return a local cache with a size and a time limit.
	 * 
	 * @param aMaxSize
	 *            max size.
	 * @param aMaxLifeTimeInMs
	 *            a time limit for the cache
	 * @return a time limited cache
	 */
	public static LocalCache getSizeAndTimeLimitedLocalCache(int aMaxSize, int aMaxLifeTimeInMs) {
		LocalCache localCache = new LocalCache(aMaxSize);
		localCache.setTimeLimited(true);
		localCache.setMaxLifeTime(aMaxLifeTimeInMs);
		return localCache;
	}

	/**
	 * Get an Object from cache.
	 * 
	 * If returned result is null, a get from the source should be done.
	 * 
	 * @param key
	 *            the key
	 * @return the cached result
	 */
	public Object get(Object key) {

		if (timeLimited) {
			// init de la date
			if (lastUpdateDate == null) {
				lastUpdateDate = new Date();
			}

			// si la durée de vie du cache a expiré, on le vide
			if ((new Date().getTime()) - lastUpdateDate.getTime() >= maxLifeTime) {
				cachemap.clear();
				lastUpdateDate = new Date();
			}
		}

		return cachemap.get(key);
	}

	/**
	 * Put an Object in cache.
	 * 
	 * @param key
	 *            the key
	 * @param value
	 *            the value
	 */
	public void put(Object key, Object value) {
		// Si la taille du cache est trop grande, le cache est remis � z�ro
		if ((maxSize != -1) && (cachemap.size() >= maxSize)) {
			cachemap.clear();
			lastUpdateDate = new Date();
		}

		cachemap.put(key, value);
	}

	/**
	 * Reset the cache.
	 */
	public void reset() {
		cachemap.clear();
		lastUpdateDate = new Date();
	}

	/**
	 * Return the last time the cache was updated.
	 * 
	 * @return Date
	 */
	public Date getLastUpdateDate() {
		return new Date(lastUpdateDate.getTime());
	}

	/**
	 * set the last time the cache was updated.
	 * 
	 * @param date
	 *            the date
	 */
	public void setLastUpdateDate(Date date) {
		lastUpdateDate = new Date(date.getTime());
	}

	/**
	 * Return true is the cache is time limited.
	 * 
	 * @return boolean
	 */
	public boolean isTimeLimited() {
		return timeLimited;
	}

	/**
	 * Set if the cache is time limited.
	 *
	 * @param isTimeLimited
	 *            true if limited
	 */
	public void setTimeLimited(boolean isTimeLimited) {
		timeLimited = isTimeLimited;
	}

	/**
	 * Return the max lifetime of the cache.
	 * 
	 * @return long lifetime in ms
	 */
	public long getMaxLifeTime() {
		return maxLifeTime;
	}

	/**
	 * Set the max lifetime of the cache.
	 * 
	 * @param lifetime
	 *            the lifetime in ms
	 */
	public void setMaxLifeTime(long lifetime) {
		maxLifeTime = lifetime;
	}

}