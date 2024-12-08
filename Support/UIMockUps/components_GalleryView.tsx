import React from 'react'
import { FloatingWindow } from './FloatingWindow'

interface Album {
  id: string
  title: string
  artist: string
  coverUrl: string
}

const AlbumCard: React.FC<Album> = ({ title, artist, coverUrl }) => (
  <div className="flex flex-col items-center">
    <img src={coverUrl} alt={`${title} by ${artist}`} className="w-32 h-32 rounded-lg shadow-lg hover:scale-105 transition-transform duration-200" />
    <h3 className="mt-2 text-sm font-semibold text-white">{title}</h3>
    <p className="text-xs text-gray-300">{artist}</p>
  </div>
)

const AlbumRow: React.FC<{ title: string; albums: Album[] }> = ({ title, albums }) => (
  <div className="mb-6">
    <h2 className="text-xl font-bold mb-3 text-white">{title}</h2>
    <div className="flex space-x-4 overflow-x-auto pb-4">
      {albums.map((album) => (
        <AlbumCard key={album.id} {...album} />
      ))}
    </div>
  </div>
)

export const GalleryView: React.FC = () => {
  // This would be fetched from Apple Music API in a real implementation
  const dummyAlbums: Album[] = [
    { id: '1', title: 'Album 1', artist: 'Artist 1', coverUrl: '/placeholder.svg?height=128&width=128' },
    { id: '2', title: 'Album 2', artist: 'Artist 2', coverUrl: '/placeholder.svg?height=128&width=128' },
    { id: '3', title: 'Album 3', artist: 'Artist 3', coverUrl: '/placeholder.svg?height=128&width=128' },
    { id: '4', title: 'Album 4', artist: 'Artist 4', coverUrl: '/placeholder.svg?height=128&width=128' },
  ]

  return (
    <FloatingWindow className="w-full max-w-4xl mx-auto overflow-y-auto max-h-screen">
      <h1 className="text-3xl font-bold mb-6 text-white">Dolby Atmos Albums</h1>
      <AlbumRow title="Your Playlists" albums={dummyAlbums} />
      <AlbumRow title="New Releases" albums={dummyAlbums} />
      <AlbumRow title="Trending" albums={dummyAlbums} />
      <AlbumRow title="Electronic" albums={dummyAlbums} />
    </FloatingWindow>
  )
}

