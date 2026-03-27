export default function SearchBar({ value, onChange }) {
    return (
        <input
            id="search-bar"
            className="search-bar"
            value={value}
            onChange={e => onChange(e.target.value)}
            placeholder="Search notes..."
        />
    )
}
